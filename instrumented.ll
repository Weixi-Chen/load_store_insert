; ModuleID = 'test.ll'
source_filename = "test.c"
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-unknown-linux-gnu"

@.str = private unnamed_addr constant [12 x i8] c"Result: %d\0A\00", align 1
@0 = private unnamed_addr constant [16 x i8] c"Store Detected\0A\00", align 1
@1 = private unnamed_addr constant [16 x i8] c"Store Detected\0A\00", align 1
@2 = private unnamed_addr constant [15 x i8] c"Load Detected\0A\00", align 1
@3 = private unnamed_addr constant [16 x i8] c"Store Detected\0A\00", align 1
@4 = private unnamed_addr constant [15 x i8] c"Load Detected\0A\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = call i32 (ptr, ...) @printf(ptr @0)
  store i32 0, ptr %1, align 4
  %5 = call i32 (ptr, ...) @printf(ptr @1)
  store i32 10, ptr %2, align 4
  %6 = call i32 (ptr, ...) @printf(ptr @2)
  %7 = load i32, ptr %2, align 4
  %8 = add nsw i32 %7, 5
  %9 = call i32 (ptr, ...) @printf(ptr @3)
  store i32 %8, ptr %3, align 4
  %10 = call i32 (ptr, ...) @printf(ptr @4)
  %11 = load i32, ptr %3, align 4
  %12 = call i32 (ptr, ...) @printf(ptr noundef @.str, i32 noundef %11)
  ret i32 0
}

declare i32 @printf(ptr noundef, ...) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fp-armv8,+neon,+outline-atomics,+v8a,-fmv" }
attributes #1 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fp-armv8,+neon,+outline-atomics,+v8a,-fmv" }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{i32 7, !"frame-pointer", i32 1}
!5 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
