#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Module.h>
#include <llvm/IRReader/IRReader.h>
#include <llvm/Support/SourceMgr.h>
#include <llvm/Support/raw_ostream.h>
#include <llvm/Transforms/Utils/BasicBlockUtils.h>
#include <llvm/IR/InstIterator.h>
#include <llvm/IR/Instructions.h>
#include <llvm/IR/DebugInfo.h>
#include <set>

using namespace llvm;
#include <iostream>
using namespace std;

void modify(Module*);

int main(int argc, char **argv){
    if (argc != 3) {
        cerr << "usage: " << argv[0] 
             << " [inputFileName] [OutputFileName]" << endl;
        exit(0);
    }

    SMDiagnostic Err;
    LLVMContext Context;
    StringRef InputFileName(argv[1]);
    unique_ptr<Module> M = parseIRFile(InputFileName, Err, Context);
    if(!M) return Err.print(argv[0], errs()), 1; 

    Module *mod = M.get();
    modify(mod);
    
    error_code Code;
    StringRef OutputFileName(argv[2]);
    raw_fd_ostream out(OutputFileName, Code);
    M->print(out, nullptr);
    out.close();
    return 0;
}

void modify(Module *mod) {
    LLVMContext &Context = mod->getContext();
    IRBuilder<> Builder(Context);

    // 创建插桩函数声明
    FunctionType *hookType = FunctionType::get(Type::getVoidTy(Context), {Type::getInt8PtrTy(Context), Type::getInt32Ty(Context)}, false);
    FunctionCallee memoryLoadHook = mod->getOrInsertFunction("memoryLoadHook", hookType);
    FunctionCallee memoryStoreHook = mod->getOrInsertFunction("memoryStoreHook", hookType);
    FunctionCallee lockAddHook = mod->getOrInsertFunction("lockAddHook", hookType);
    FunctionCallee lockRemoveHook = mod->getOrInsertFunction("lockRemoveHook", hookType);

    for (Function &F : *mod) {
        set<Value*> localVars;
        for (Instruction &I : instructions(F)) {
            if (AllocaInst *allocaInst = dyn_cast<AllocaInst>(&I)) {
                localVars.insert(allocaInst);
            }
        }

        for (Instruction &I : instructions(F)) {
            unsigned lineNumber = 0;
            if (DILocation *Loc = I.getDebugLoc()) {
                lineNumber = Loc->getLine();
            }

            // 插桩内存访问
            if (isa<LoadInst>(&I) && !localVars.count(cast<LoadInst>(&I)->getPointerOperand())) {
                Value *Addr = cast<LoadInst>(&I)->getPointerOperand();
                Builder.SetInsertPoint(&I);
                Value *AddrAsInt8Ptr = Builder.CreateBitCast(Addr, Type::getInt8PtrTy(Context));
                Value *LineNum = ConstantInt::get(Type::getInt32Ty(Context), lineNumber);
                Builder.CreateCall(memoryLoadHook, {AddrAsInt8Ptr, LineNum});
            }
            if (isa<StoreInst>(&I) && !localVars.count(cast<StoreInst>(&I)->getPointerOperand())) {
                Value *Addr = cast<StoreInst>(&I)->getPointerOperand();
                Builder.SetInsertPoint(&I);
                Value *AddrAsInt8Ptr = Builder.CreateBitCast(Addr, Type::getInt8PtrTy(Context));
                Value *LineNum = ConstantInt::get(Type::getInt32Ty(Context), lineNumber);
                Builder.CreateCall(memoryStoreHook, {AddrAsInt8Ptr, LineNum});
            }

            // 插桩锁操作
            if (isa<CallInst>(&I)) {
                CallInst *callInst = cast<CallInst>(&I);
                Function *calledFunc = callInst->getCalledFunction();
                if (calledFunc && (calledFunc->getName() == "pthread_mutex_lock")) {
                    Builder.SetInsertPoint(callInst);
                    Value *AddrAsInt8Ptr = Builder.CreateBitCast(callInst->getArgOperand(0), Type::getInt8PtrTy(Context));
                    Value *LineNum = ConstantInt::get(Type::getInt32Ty(Context), lineNumber);
                    Builder.CreateCall(lockAddHook, {AddrAsInt8Ptr, LineNum});
                }
                if (calledFunc && (calledFunc->getName() == "pthread_mutex_unlock")) {
                    Builder.SetInsertPoint(callInst);
                    Value *AddrAsInt8Ptr = Builder.CreateBitCast(callInst->getArgOperand(0), Type::getInt8PtrTy(Context));
                    Value *LineNum = ConstantInt::get(Type::getInt32Ty(Context), lineNumber);
                    Builder.CreateCall(lockRemoveHook, {AddrAsInt8Ptr, LineNum});
                }
            }
        }
    }
}
