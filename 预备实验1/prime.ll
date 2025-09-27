; ModuleID = 'prime.c'
; source_filename = "prime.c"

declare i32 @getint()
declare void @putch(i32)

; ---------- prime 函数 ----------
define void @prime(i32 %n) {
entry:
  %i = alloca i32, align 4
  store i32 2, i32* %i, align 4
  br label %for.cond

; ---------- for 循环 ----------
for.cond:
  %i.val = load i32, i32* %i, align 4
  %n.minus1 = sub i32 %n, 1          ; 先计算 n-1
  %cmp = icmp sle i32 %i.val, %n.minus1
  br i1 %cmp, label %for.body, label %for.end

for.body:
  %i.val2 = load i32, i32* %i, align 4
  %rem = srem i32 %n, %i.val2
  %iszero = icmp eq i32 %rem, 0
  br i1 %iszero, label %for.break, label %for.inc

for.inc:
  %i.old = load i32, i32* %i, align 4
  %i.next = add i32 %i.old, 1
  store i32 %i.next, i32* %i, align 4
  br label %for.cond

for.break:
  br label %for.end

for.end:
  %i.final = load i32, i32* %i, align 4
  %cmp2 = icmp sge i32 %i.final, %n
  br i1 %cmp2, label %if.then, label %if.else

if.then:
  call void @putch(i32 121) ; 'y'
  br label %if.end

if.else:
  call void @putch(i32 110) ; 'n'
  br label %if.end

if.end:
  call void @putch(i32 10) ; 换行
  ret void
}

; ---------- main 函数 ----------
define i32 @main() {
entry:
  %n = alloca i32, align 4
  %call = call i32 @getint()
  store i32 %call, i32* %n, align 4
  %n.val = load i32, i32* %n, align 4
  call void @prime(i32 %n.val)
  ret i32 0
}
