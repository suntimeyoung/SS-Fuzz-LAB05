; ModuleID = '../bin/atomicity_violation_example.ll'
source_filename = "../../testcases/atomicity_violation_example.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%"class.std::ios_base::Init" = type { i8 }
%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { %struct.__pthread_internal_list*, %struct.__pthread_internal_list* }
%"class.std::basic_istream" = type { i32 (...)**, i64, %"class.std::basic_ios" }
%"class.std::basic_ios" = type { %"class.std::ios_base", %"class.std::basic_ostream"*, i8, i8, %"class.std::basic_streambuf"*, %"class.std::ctype"*, %"class.std::num_put"*, %"class.std::num_get"* }
%"class.std::ios_base" = type { i32 (...)**, i64, i64, i32, i32, i32, %"struct.std::ios_base::_Callback_list"*, %"struct.std::ios_base::_Words", [8 x %"struct.std::ios_base::_Words"], i32, %"struct.std::ios_base::_Words"*, %"class.std::locale" }
%"struct.std::ios_base::_Callback_list" = type { %"struct.std::ios_base::_Callback_list"*, void (i32, %"class.std::ios_base"*, i32)*, i32, i32 }
%"struct.std::ios_base::_Words" = type { i8*, i64 }
%"class.std::locale" = type { %"class.std::locale::_Impl"* }
%"class.std::locale::_Impl" = type { i32, %"class.std::locale::facet"**, i64, %"class.std::locale::facet"**, i8** }
%"class.std::locale::facet" = type <{ i32 (...)**, i32, [4 x i8] }>
%"class.std::basic_ostream" = type { i32 (...)**, %"class.std::basic_ios" }
%"class.std::basic_streambuf" = type { i32 (...)**, i8*, i8*, i8*, i8*, i8*, i8*, %"class.std::locale" }
%"class.std::ctype" = type <{ %"class.std::locale::facet.base", [4 x i8], %struct.__locale_struct*, i8, [7 x i8], i32*, i32*, i16*, i8, [256 x i8], [256 x i8], i8, [6 x i8] }>
%"class.std::locale::facet.base" = type <{ i32 (...)**, i32 }>
%struct.__locale_struct = type { [13 x %struct.__locale_data*], i16*, i32*, i32*, [13 x i8*] }
%struct.__locale_data = type opaque
%"class.std::num_put" = type { %"class.std::locale::facet.base", [4 x i8] }
%"class.std::num_get" = type { %"class.std::locale::facet.base", [4 x i8] }
%union.pthread_attr_t = type { i64, [48 x i8] }

@_ZStL8__ioinit = internal global %"class.std::ios_base::Init" zeroinitializer, align 1
@__dso_handle = external hidden global i8
@value = dso_local global i32 0, align 4
@run_time = dso_local global i32 0, align 4
@mutex = dso_local global %union.pthread_mutex_t zeroinitializer, align 8
@_ZSt3cin = external dso_local global %"class.std::basic_istream", align 8
@_ZSt4cout = external dso_local global %"class.std::basic_ostream", align 8
@.str = private unnamed_addr constant [14 x i8] c"Final value: \00", align 1
@llvm.global_ctors = appending global [1 x { i32, void ()*, i8* }] [{ i32, void ()*, i8* } { i32 65535, void ()* @_GLOBAL__sub_I_atomicity_violation_example.cpp, i8* null }]

; Function Attrs: noinline uwtable
define internal void @__cxx_global_var_init() #0 section ".text.startup" {
  call void @_ZNSt8ios_base4InitC1Ev(%"class.std::ios_base::Init"* nonnull dereferenceable(1) @_ZStL8__ioinit)
  %1 = call i32 @__cxa_atexit(void (i8*)* bitcast (void (%"class.std::ios_base::Init"*)* @_ZNSt8ios_base4InitD1Ev to void (i8*)*), i8* getelementptr inbounds (%"class.std::ios_base::Init", %"class.std::ios_base::Init"* @_ZStL8__ioinit, i32 0, i32 0), i8* @__dso_handle) #3
  ret void
}

declare dso_local void @_ZNSt8ios_base4InitC1Ev(%"class.std::ios_base::Init"* nonnull dereferenceable(1)) unnamed_addr #1

; Function Attrs: nounwind
declare dso_local void @_ZNSt8ios_base4InitD1Ev(%"class.std::ios_base::Init"* nonnull dereferenceable(1)) unnamed_addr #2

; Function Attrs: nounwind
declare dso_local i32 @__cxa_atexit(void (i8*)*, i8*, i8*) #3

; Function Attrs: noinline nounwind optnone uwtable mustprogress
define dso_local i8* @_Z3addPv(i8* %0) #4 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = bitcast i8** %2 to i8*
  call void @memoryStoreHook(i8* %5)
  store i8* %0, i8** %2, align 8
  %6 = bitcast i32* %3 to i8*
  call void @memoryStoreHook(i8* %6)
  store i32 0, i32* %3, align 4
  br label %7

7:                                                ; preds = %23, %1
  %8 = bitcast i32* %3 to i8*
  call void @memoryLoadHook(i8* %8)
  %9 = load i32, i32* %3, align 4
  call void @memoryLoadHook(i8* bitcast (i32* @run_time to i8*))
  %10 = load i32, i32* @run_time, align 4
  %11 = icmp slt i32 %9, %10
  br i1 %11, label %12, label %28

12:                                               ; preds = %7
  call void @lockAddHook(i8* bitcast (%union.pthread_mutex_t* @mutex to i8*))
  %13 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* @mutex) #3
  call void @memoryLoadHook(i8* bitcast (i32* @value to i8*))
  %14 = load i32, i32* @value, align 4
  %15 = bitcast i32* %4 to i8*
  call void @memoryStoreHook(i8* %15)
  store i32 %14, i32* %4, align 4
  %16 = bitcast i32* %4 to i8*
  call void @memoryLoadHook(i8* %16)
  %17 = load i32, i32* %4, align 4
  %18 = add nsw i32 %17, 1
  %19 = bitcast i32* %4 to i8*
  call void @memoryStoreHook(i8* %19)
  store i32 %18, i32* %4, align 4
  %20 = bitcast i32* %4 to i8*
  call void @memoryLoadHook(i8* %20)
  %21 = load i32, i32* %4, align 4
  call void @memoryStoreHook(i8* bitcast (i32* @value to i8*))
  store i32 %21, i32* @value, align 4
  call void @lockRemoveHook(i8* bitcast (%union.pthread_mutex_t* @mutex to i8*))
  %22 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* @mutex) #3
  br label %23

23:                                               ; preds = %12
  %24 = bitcast i32* %3 to i8*
  call void @memoryLoadHook(i8* %24)
  %25 = load i32, i32* %3, align 4
  %26 = add nsw i32 %25, 1
  %27 = bitcast i32* %3 to i8*
  call void @memoryStoreHook(i8* %27)
  store i32 %26, i32* %3, align 4
  br label %7, !llvm.loop !2

28:                                               ; preds = %7
  ret i8* null
}

; Function Attrs: nounwind
declare dso_local i32 @pthread_mutex_lock(%union.pthread_mutex_t*) #2

; Function Attrs: nounwind
declare dso_local i32 @pthread_mutex_unlock(%union.pthread_mutex_t*) #2

; Function Attrs: noinline nounwind optnone uwtable mustprogress
define dso_local i8* @_Z8subtractPv(i8* %0) #4 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = bitcast i8** %2 to i8*
  call void @memoryStoreHook(i8* %5)
  store i8* %0, i8** %2, align 8
  %6 = bitcast i32* %3 to i8*
  call void @memoryStoreHook(i8* %6)
  store i32 0, i32* %3, align 4
  br label %7

7:                                                ; preds = %21, %1
  %8 = bitcast i32* %3 to i8*
  call void @memoryLoadHook(i8* %8)
  %9 = load i32, i32* %3, align 4
  call void @memoryLoadHook(i8* bitcast (i32* @run_time to i8*))
  %10 = load i32, i32* @run_time, align 4
  %11 = icmp slt i32 %9, %10
  br i1 %11, label %12, label %26

12:                                               ; preds = %7
  call void @memoryLoadHook(i8* bitcast (i32* @value to i8*))
  %13 = load i32, i32* @value, align 4
  %14 = bitcast i32* %4 to i8*
  call void @memoryStoreHook(i8* %14)
  store i32 %13, i32* %4, align 4
  %15 = bitcast i32* %4 to i8*
  call void @memoryLoadHook(i8* %15)
  %16 = load i32, i32* %4, align 4
  %17 = sub nsw i32 %16, 1
  %18 = bitcast i32* %4 to i8*
  call void @memoryStoreHook(i8* %18)
  store i32 %17, i32* %4, align 4
  %19 = bitcast i32* %4 to i8*
  call void @memoryLoadHook(i8* %19)
  %20 = load i32, i32* %4, align 4
  call void @memoryStoreHook(i8* bitcast (i32* @value to i8*))
  store i32 %20, i32* @value, align 4
  br label %21

21:                                               ; preds = %12
  %22 = bitcast i32* %3 to i8*
  call void @memoryLoadHook(i8* %22)
  %23 = load i32, i32* %3, align 4
  %24 = add nsw i32 %23, 1
  %25 = bitcast i32* %3 to i8*
  call void @memoryStoreHook(i8* %25)
  store i32 %24, i32* %3, align 4
  br label %7, !llvm.loop !4

26:                                               ; preds = %7
  ret i8* null
}

; Function Attrs: noinline norecurse optnone uwtable mustprogress
define dso_local i32 @main() #5 {
  %1 = alloca i32, align 4
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  %4 = bitcast i32* %1 to i8*
  call void @memoryStoreHook(i8* %4)
  store i32 0, i32* %1, align 4
  %5 = call nonnull align 8 dereferenceable(16) %"class.std::basic_istream"* @_ZNSirsERi(%"class.std::basic_istream"* nonnull dereferenceable(16) @_ZSt3cin, i32* nonnull align 4 dereferenceable(4) @run_time)
  %6 = call i32 @pthread_create(i64* %2, %union.pthread_attr_t* null, i8* (i8*)* @_Z3addPv, i8* null) #3
  %7 = call i32 @pthread_create(i64* %3, %union.pthread_attr_t* null, i8* (i8*)* @_Z8subtractPv, i8* null) #3
  %8 = bitcast i64* %2 to i8*
  call void @memoryLoadHook(i8* %8)
  %9 = load i64, i64* %2, align 8
  %10 = call i32 @pthread_join(i64 %9, i8** null)
  %11 = bitcast i64* %3 to i8*
  call void @memoryLoadHook(i8* %11)
  %12 = load i64, i64* %3, align 8
  %13 = call i32 @pthread_join(i64 %12, i8** null)
  %14 = call nonnull align 8 dereferenceable(8) %"class.std::basic_ostream"* @_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc(%"class.std::basic_ostream"* nonnull align 8 dereferenceable(8) @_ZSt4cout, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str, i64 0, i64 0))
  call void @memoryLoadHook(i8* bitcast (i32* @value to i8*))
  %15 = load i32, i32* @value, align 4
  %16 = call nonnull align 8 dereferenceable(8) %"class.std::basic_ostream"* @_ZNSolsEi(%"class.std::basic_ostream"* nonnull dereferenceable(8) %14, i32 %15)
  %17 = call nonnull align 8 dereferenceable(8) %"class.std::basic_ostream"* @_ZNSolsEPFRSoS_E(%"class.std::basic_ostream"* nonnull dereferenceable(8) %16, %"class.std::basic_ostream"* (%"class.std::basic_ostream"*)* @_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_)
  ret i32 0
}

declare dso_local nonnull align 8 dereferenceable(16) %"class.std::basic_istream"* @_ZNSirsERi(%"class.std::basic_istream"* nonnull dereferenceable(16), i32* nonnull align 4 dereferenceable(4)) #1

; Function Attrs: nounwind
declare dso_local i32 @pthread_create(i64*, %union.pthread_attr_t*, i8* (i8*)*, i8*) #2

declare dso_local i32 @pthread_join(i64, i8**) #1

declare dso_local nonnull align 8 dereferenceable(8) %"class.std::basic_ostream"* @_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc(%"class.std::basic_ostream"* nonnull align 8 dereferenceable(8), i8*) #1

declare dso_local nonnull align 8 dereferenceable(8) %"class.std::basic_ostream"* @_ZNSolsEi(%"class.std::basic_ostream"* nonnull dereferenceable(8), i32) #1

declare dso_local nonnull align 8 dereferenceable(8) %"class.std::basic_ostream"* @_ZNSolsEPFRSoS_E(%"class.std::basic_ostream"* nonnull dereferenceable(8), %"class.std::basic_ostream"* (%"class.std::basic_ostream"*)*) #1

declare dso_local nonnull align 8 dereferenceable(8) %"class.std::basic_ostream"* @_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_(%"class.std::basic_ostream"* nonnull align 8 dereferenceable(8)) #1

; Function Attrs: noinline uwtable
define internal void @_GLOBAL__sub_I_atomicity_violation_example.cpp() #0 section ".text.startup" {
  call void @__cxx_global_var_init()
  ret void
}

declare void @memoryLoadHook(i8*)

declare void @memoryStoreHook(i8*)

declare void @lockAddHook(i8*)

declare void @lockRemoveHook(i8*)

attributes #0 = { noinline uwtable "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind }
attributes #4 = { noinline nounwind optnone uwtable mustprogress "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { noinline norecurse optnone uwtable mustprogress "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"Ubuntu clang version 12.0.1-19ubuntu3"}
!2 = distinct !{!2, !3}
!3 = !{!"llvm.loop.mustprogress"}
!4 = distinct !{!4, !3}
