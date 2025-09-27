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
prime:
    addi sp, sp, -16     # 分配栈空间保存寄存器
    sw ra, 12(sp)        # 保存返回地址
    sw s0, 8(sp)         # 保存s0（n）
    sw t1, 4(sp)         # 保存t1（i）
    sw t2, 0(sp)         # 保存临时变量
    
    mv s0, a0            # s0 = n（保存输入值）
    
    li t1, 2             # i = 2（循环变量初始化）
loop_start:
    # 循环条件：i <= n-1？
    addi t2, s0, -1      # t2 = n-1
    bgt t1, t2, loop_end # 若i > n-1，跳出循环
    
    # 判断n % i == 0？
    rem t2, s0, t1       # t2 = n % i
    beqz t2, loop_end    # 若余数为0，跳出循环
    
    addi t1, t1, 1       # i++
    j loop_start         # 继续循环

loop_end:
    # 判断i >= n？
    bge t1, s0, print_yes # 若i >= n，输出"y\n"
    
print_no:
    la a0, no_str        # 加载非素数字符串地址
    jal ra, putf         # 输出
    j prime_end

print_yes:
    la a0, yes_str       # 加载素数字符串地址
    jal ra, putf         # 输出

prime_end:
    # 恢复寄存器并返回
    lw t2, 0(sp)
    lw t1, 4(sp)
    lw s0, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16
    ret
