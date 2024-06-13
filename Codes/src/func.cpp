#include <iostream>

using namespace std;

extern "C" void memoryAccessHook(void* addr) {
    // 在这里处理内存访问的逻辑
    cout << "Memory access at: " << addr << endl;
}

extern "C" void lockOperationHook(void* addr) {
    // 在这里处理锁操作的逻辑
    cout << "Lock operation on: " << addr << endl;
}
