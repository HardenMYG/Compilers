    .section .data
prompt: .asciz "Enter an integer: "
yes:    .ascii "y\n"
no:     .ascii "n\n"
buf:    .space 32          # 输入缓冲区

    .section .text
    .globl _start
_start:
    # 读取输入
    li a7, 63              # sys_read
    li a0, 0               # stdin
    la a1, buf
    li a2, 32
    ecall                  # 返回字节数在 a0

    # 处理输入：把 '\n' 改成 '\0'
    mv t0, a0              # t0 = 读取字节数
    la t1, buf
    add t1, t1, t0
    sb zero, 0(t1)

    # 调用 atoi
    la a0, buf
    jal ra, atoi
    mv s0, a0              # s0 = 输入的整数

    # 调用 is_prime
    mv a0, s0
    jal ra, is_prime

    # 输出结果
    beqz a0, not_prime     # a0=0 -> 合数
prime:
    li a7, 64
    li a0, 1
    la a1, yes
    li a2, 2
    ecall
    j exit
not_prime:
    li a7, 64
    li a0, 1
    la a1, no
    li a2, 2
    ecall

exit:
    li a7, 93
    li a0, 0
    ecall

# -------------------------------
# atoi(char* str) -> int
# -------------------------------
atoi:
    mv t0, a0        # t0 = str 指针
    li a1, 0         # a1 = result
atoi_loop:
    lbu t2, 0(t0)
    beqz t2, atoi_end
    li t3, '0'
    blt t2, t3, atoi_end
    li t3, '9'
    bgt t2, t3, atoi_end

    addi t2, t2, -48          # t2 = digit

    li t4, 10
    mul a1, a1, t4            # result *= 10
    add a1, a1, t2            # result += digit

    addi t0, t0, 1
    j atoi_loop
atoi_end:
    mv a0, a1
    ret

# -------------------------------
# is_prime(int n) -> a0=1 if prime, 0 if not
# -------------------------------
is_prime:
    li t0, 2
    blt a0, t0, not_prime_ret
    beq a0, t0, prime_ret

    li t1, 2          # i = 2
loop_div:
    mul t2, t1, t1
    bgt t2, a0, prime_ret     # i*i > n -> prime

    rem t3, a0, t1
    beqz t3, not_prime_ret

    addi t1, t1, 1
    j loop_div
prime_ret:
    li a0, 1
    ret
not_prime_ret:
    li a0, 0
    ret
