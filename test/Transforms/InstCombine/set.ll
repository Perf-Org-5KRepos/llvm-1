; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; This test makes sure that all icmp instructions are eliminated.
; RUN: opt < %s -instcombine -S | FileCheck %s

@X = external global i32

define i1 @test1(i32 %A) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    ret i1 false
;
  %B = icmp eq i32 %A, %A
  ; Never true
  %C = icmp eq i32* @X, null
  %D = and i1 %B, %C
  ret i1 %D
}

define i1 @test2(i32 %A) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    ret i1 true
;
  %B = icmp ne i32 %A, %A
  ; Never false
  %C = icmp ne i32* @X, null
  %D = or i1 %B, %C
  ret i1 %D
}

define i1 @test3(i32 %A) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    ret i1 false
;
  %B = icmp slt i32 %A, %A
  ret i1 %B
}


define i1 @test4(i32 %A) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    ret i1 false
;
  %B = icmp sgt i32 %A, %A
  ret i1 %B
}

define i1 @test5(i32 %A) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    ret i1 true
;
  %B = icmp sle i32 %A, %A
  ret i1 %B
}

define i1 @test6(i32 %A) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:    ret i1 true
;
  %B = icmp sge i32 %A, %A
  ret i1 %B
}

define i1 @test7(i32 %A) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:    ret i1 true
;
  %B = icmp uge i32 %A, 0
  ret i1 %B
}

define i1 @test8(i32 %A) {
; CHECK-LABEL: @test8(
; CHECK-NEXT:    ret i1 false
;
  %B = icmp ult i32 %A, 0
  ret i1 %B
}

;; test operations on boolean values these should all be eliminated$a
define i1 @test9(i1 %A) {
; CHECK-LABEL: @test9(
; CHECK-NEXT:    ret i1 false
;
  %B = icmp ult i1 %A, false
  ret i1 %B
}

define i1 @test10(i1 %A) {
; CHECK-LABEL: @test10(
; CHECK-NEXT:    ret i1 false
;
  %B = icmp ugt i1 %A, true
  ret i1 %B
}

define i1 @test11(i1 %A) {
; CHECK-LABEL: @test11(
; CHECK-NEXT:    ret i1 true
;
  %B = icmp ule i1 %A, true
  ret i1 %B
}

define i1 @test12(i1 %A) {
; CHECK-LABEL: @test12(
; CHECK-NEXT:    ret i1 true
;
  %B = icmp uge i1 %A, false
  ret i1 %B
}

define i1 @test13(i1 %A, i1 %B) {
; CHECK-LABEL: @test13(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i1 %B, true
; CHECK-NEXT:    [[C:%.*]] = or i1 [[TMP1]], %A
; CHECK-NEXT:    ret i1 [[C]]
;
  %C = icmp uge i1 %A, %B
  ret i1 %C
}

define <2 x i1> @test13vec(<2 x i1> %A, <2 x i1> %B) {
; CHECK-LABEL: @test13vec(
; CHECK-NEXT:    [[TMP1:%.*]] = xor <2 x i1> %B, <i1 true, i1 true>
; CHECK-NEXT:    [[C:%.*]] = or <2 x i1> [[TMP1]], %A
; CHECK-NEXT:    ret <2 x i1> [[C]]
;
  %C = icmp uge <2 x i1> %A, %B
  ret <2 x i1> %C
}

define i1 @test14(i1 %A, i1 %B) {
; CHECK-LABEL: @test14(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i1 %A, %B
; CHECK-NEXT:    [[C:%.*]] = xor i1 [[TMP1]], true
; CHECK-NEXT:    ret i1 [[C]]
;
  %C = icmp eq i1 %A, %B
  ret i1 %C
}

define <3 x i1> @test14vec(<3 x i1> %A, <3 x i1> %B) {
; CHECK-LABEL: @test14vec(
; CHECK-NEXT:    [[TMP1:%.*]] = xor <3 x i1> %A, %B
; CHECK-NEXT:    [[C:%.*]] = xor <3 x i1> [[TMP1]], <i1 true, i1 true, i1 true>
; CHECK-NEXT:    ret <3 x i1> [[C]]
;
  %C = icmp eq <3 x i1> %A, %B
  ret <3 x i1> %C
}

define i1 @bool_eq0(i64 %a) {
; CHECK-LABEL: @bool_eq0(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp sgt i64 %a, 1
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %b = icmp sgt i64 %a, 0
  %c = icmp eq i64 %a, 1
  %notc = icmp eq i1 %c, false
  %and = and i1 %b, %notc
  ret i1 %and
}

; FIXME: This is equivalent to the previous test.

define i1 @xor_of_icmps(i64 %a) {
; CHECK-LABEL: @xor_of_icmps(
; CHECK-NEXT:    [[B:%.*]] = icmp sgt i64 %a, 0
; CHECK-NEXT:    [[C:%.*]] = icmp eq i64 %a, 1
; CHECK-NEXT:    [[XOR:%.*]] = xor i1 [[C]], [[B]]
; CHECK-NEXT:    ret i1 [[XOR]]
;
  %b = icmp sgt i64 %a, 0
  %c = icmp eq i64 %a, 1
  %xor = xor i1 %c, %b
  ret i1 %xor
}

define i1 @test16(i32 %A) {
; CHECK-LABEL: @test16(
; CHECK-NEXT:    ret i1 false
;
  %B = and i32 %A, 5
  ; Is never true
  %C = icmp eq i32 %B, 8
  ret i1 %C
}

define i1 @test17(i8 %A) {
; CHECK-LABEL: @test17(
; CHECK-NEXT:    ret i1 false
;
  %B = or i8 %A, 1
  ; Always false
  %C = icmp eq i8 %B, 2
  ret i1 %C
}

define i1 @test18(i1 %C, i32 %a) {
; CHECK-LABEL: @test18(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 %C, label %endif, label %else
; CHECK:       else:
; CHECK-NEXT:    br label %endif
; CHECK:       endif:
; CHECK-NEXT:    ret i1 true
;
entry:
  br i1 %C, label %endif, label %else

else:
  br label %endif

endif:
  %b.0 = phi i32 [ 0, %entry ], [ 1, %else ]
  %tmp.4 = icmp slt i32 %b.0, 123
  ret i1 %tmp.4
}

define i1 @test19(i1 %A, i1 %B) {
; CHECK-LABEL: @test19(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i1 %A, %B
; CHECK-NEXT:    [[C:%.*]] = xor i1 [[TMP1]], true
; CHECK-NEXT:    ret i1 [[C]]
;
  %a = zext i1 %A to i32
  %b = zext i1 %B to i32
  %C = icmp eq i32 %a, %b
  ret i1 %C
}

define i32 @test20(i32 %A) {
; CHECK-LABEL: @test20(
; CHECK-NEXT:    [[B:%.*]] = and i32 %A, 1
; CHECK-NEXT:    ret i32 [[B]]
;
  %B = and i32 %A, 1
  %C = icmp ne i32 %B, 0
  %D = zext i1 %C to i32
  ret i32 %D
}

define i32 @test21(i32 %a) {
; CHECK-LABEL: @test21(
; CHECK-NEXT:    [[TMP_6:%.*]] = lshr i32 %a, 2
; CHECK-NEXT:    [[TMP_6_LOBIT:%.*]] = and i32 [[TMP_6]], 1
; CHECK-NEXT:    ret i32 [[TMP_6_LOBIT]]
;
  %tmp.6 = and i32 %a, 4
  %not.tmp.7 = icmp ne i32 %tmp.6, 0
  %retval = zext i1 %not.tmp.7 to i32
  ret i32 %retval
}

define i1 @test22(i32 %A, i32 %X) {
; CHECK-LABEL: @test22(
; CHECK-NEXT:    ret i1 true
;
  %B = and i32 %A, 100663295
  %C = icmp ult i32 %B, 268435456
  %Y = and i32 %X, 7
  %Z = icmp sgt i32 %Y, -1
  %R = or i1 %C, %Z
  ret i1 %R
}

define i32 @test23(i32 %a) {
; CHECK-LABEL: @test23(
; CHECK-NEXT:    [[TMP_1:%.*]] = and i32 %a, 1
; CHECK-NEXT:    [[TMP1:%.*]] = xor i32 [[TMP_1]], 1
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %tmp.1 = and i32 %a, 1
  %tmp.2 = icmp eq i32 %tmp.1, 0
  %tmp.3 = zext i1 %tmp.2 to i32
  ret i32 %tmp.3
}

define i32 @test24(i32 %a) {
; CHECK-LABEL: @test24(
; CHECK-NEXT:    [[TMP_1:%.*]] = lshr i32 %a, 2
; CHECK-NEXT:    [[TMP_1_LOBIT:%.*]] = and i32 [[TMP_1]], 1
; CHECK-NEXT:    [[TMP1:%.*]] = xor i32 [[TMP_1_LOBIT]], 1
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %tmp1 = and i32 %a, 4
  %tmp.1 = lshr i32 %tmp1, 2
  %tmp.2 = icmp eq i32 %tmp.1, 0
  %tmp.3 = zext i1 %tmp.2 to i32
  ret i32 %tmp.3
}

define i1 @test25(i32 %A) {
; CHECK-LABEL: @test25(
; CHECK-NEXT:    ret i1 false
;
  %B = and i32 %A, 2
  %C = icmp ugt i32 %B, 2
  ret i1 %C
}

