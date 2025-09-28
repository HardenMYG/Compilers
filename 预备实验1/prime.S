.section .rodata
# 定义输出字符串（供putf使用）
yes_str: .asciz "y\n"    # 素数输出字符串（带换行）
no_str:  .asciz "n\n"    # 非素数输出字符串（带换行）

    .section .text
    .globl main
main:
    # 主函数：读取输入并调用prime函数
    jal ra, getint       # 调用getint获取输入
    mv a0, a0            # 将输入值作为参数传递给prime
    jal ra, prime        # 调用prime函数判断并输出结果
    
    # 程序退出
    li a7, 93
    li a0, 0
    ecall

# -------------------------------
# void prime(int n)
# 功能：判断n是否为素数并输出结果
# 参数：a0 = n（输入的整数）
# -------------------------------
   # assume RV64
    .section .text
    .globl prime
prime:
    addi sp, sp, -32     # 分配 32 字节栈空间（保持 16 字节对齐）
    sd ra, 24(sp)        # 保存返回地址 (8-byte)
    sd s0, 16(sp)        # 保存 s0（n）
    sd t1, 8(sp)         # 保存 t1（i）
    sd t2, 0(sp)         # 保存 t2（临时）

    mv s0, a0            # s0 = n

    li t1, 2             # i = 2
loop_start:
    addi t2, s0, -1      # t2 = n - 1
    bgt  t1, t2, loop_end # if i > n-1 -> end

    rem  t2, s0, t1      # t2 = n % i
    beqz t2, loop_end    # if remainder == 0 -> end (not prime)

    addi t1, t1, 1       # i++
    j loop_start

loop_end:
    bge  t1, s0, print_yes

print_no:
    li a0, 'n'           # putch expects char in a0
    jal ra, putch
    li a0, 10            # '\n'
    jal ra, putch
    j prime_restore

print_yes:
    li a0, 'y'
    jal ra, putch
    li a0, 10
    jal ra, putch

prime_restore:
    ld t2, 0(sp)
    ld t1, 8(sp)
    ld s0, 16(sp)
    ld ra, 24(sp)
    addi sp, sp, 32
    ret
