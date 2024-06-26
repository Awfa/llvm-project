; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 4
; RUN: opt < %s -passes=newgvn -S | FileCheck %s
; PR2503

@g_3 = external global i8		; <ptr> [#uses=2]

define i8 @func_1(i32 %x, i32 %y) nounwind  {
; CHECK-LABEL: define i8 @func_1(
; CHECK-SAME: i32 [[X:%.*]], i32 [[Y:%.*]]) #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = alloca i8, align 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[X]], [[Y]]
; CHECK-NEXT:    br i1 [[CMP]], label [[IFELSE:%.*]], label [[IFTHEN:%.*]]
; CHECK:       ifthen:
; CHECK-NEXT:    br label [[IFEND:%.*]]
; CHECK:       ifelse:
; CHECK-NEXT:    [[TMP3:%.*]] = load i8, ptr @g_3, align 1
; CHECK-NEXT:    store i8 [[TMP3]], ptr [[A]], align 1
; CHECK-NEXT:    br label [[AFTERFOR:%.*]]
; CHECK:       forcond:
; CHECK-NEXT:    store i8 poison, ptr null, align 1
; CHECK-NEXT:    br i1 false, label [[AFTERFOR]], label [[FORBODY:%.*]]
; CHECK:       forbody:
; CHECK-NEXT:    store i8 poison, ptr null, align 1
; CHECK-NEXT:    br label [[FORINC:%.*]]
; CHECK:       forinc:
; CHECK-NEXT:    store i8 poison, ptr null, align 1
; CHECK-NEXT:    br label [[FORCOND:%.*]]
; CHECK:       afterfor:
; CHECK-NEXT:    ret i8 [[TMP3]]
; CHECK:       ifend:
; CHECK-NEXT:    ret i8 0
;
entry:
  %A = alloca i8
  %cmp = icmp eq i32 %x, %y
  br i1 %cmp, label %ifelse, label %ifthen

ifthen:		; preds = %entry
  br label %ifend

ifelse:		; preds = %entry
  %tmp3 = load i8, ptr @g_3		; <i8> [#uses=0]
  store i8 %tmp3, ptr %A
  br label %afterfor

forcond:		; preds = %forinc
  br i1 false, label %afterfor, label %forbody

forbody:		; preds = %forcond
  br label %forinc

forinc:		; preds = %forbody
  br label %forcond

afterfor:		; preds = %forcond, %forcond.thread
  %tmp10 = load i8, ptr @g_3		; <i8> [#uses=0]
  ret i8 %tmp10

ifend:		; preds = %afterfor, %ifthen
  ret i8 0
}
