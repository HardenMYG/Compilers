; ModuleID = 'prime.c'
; source_filename = "prime.c"

declare i32 @getint()
declare void @putint(i32)   ; 原来的还保留
declare void @putch(i32)    ; 新增字符输出

define i32 @main() #0 {
entry:
  %i = alloca i32, align 4
  %n = alloca i32, align 4

  ; n = getint();
  %call = call i32 @getint()
  store i32 %call, i32* %n, align 4

  ; i = 2
  store i32 2, i32* %i, align 4
  br label %for.cond

; ---------- for 循环部分 ----------
for.cond:                                   ; 检查条件 i <= n-1
  %i.val = load i32, i32* %i, align 4
  %n.val = load i32, i32* %n, align 4
  %n.minus1 = add nsw i32 %n.val, -1
  %cmp = icmp sle i32 %i.val, %n.minus1
  br i1 %cmp, label %for.body, label %for.end

for.body:                                   ; if (n % i == 0) break;
  %n.val2 = load i32, i32* %n, align 4
  %i.val2 = load i32, i32* %i, align 4
  %rem = srem i32 %n.val2, %i.val2
  %cmp.rem = icmp eq i32 %rem, 0
  br i1 %cmp.rem, label %for.break, label %for.inc

for.inc:                                    ; i++
  %i.old = load i32, i32* %i, align 4
  %i.next = add nsw i32 %i.old, 1
  store i32 %i.next, i32* %i, align 4
  br label %for.cond

for.break:                                  ; break 语句
  br label %for.end

for.end:                                    ; for 结束
  %i.final = load i32, i32* %i, align 4
  %n.final = load i32, i32* %n, align 4
  %cmp2 = icmp sge i32 %i.final, %n.final
  br i1 %cmp2, label %if.then, label %if.else

; ---------- if (i >= n) 输出 'y' 否则输出 'n' ----------
if.then:
  call void @putch(i32 121) ; 'y'
  call void @putch(i32 10)  ; '\n'
  br label %return

if.else:
  call void @putch(i32 110) ; 'n'
  call void @putch(i32 10)  ; '\n'
  br label %return

return:
  ret i32 0
}
