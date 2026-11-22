.data
n:       .word 20           
str_out: .asciiz "F(n) = "

.text
main:
    lw    $a0, n            # $a0 = n
    jal   fib_rec           # doi thanh "jal fib_iter" khi do fib_iter
    move  $s0, $v0          # luu ket qua F(n)

    la    $a0, str_out      # in chuoi "F(n) = "
    li    $v0, 4
    syscall

    move  $a0, $s0          # in gia tri F(n)
    li    $v0, 1
    syscall

    li    $v0, 10           # thoat chuong trinh
    syscall
fib_rec:
    # Prologue: cap khung 12 byte, bao toan $ra, $s0, $s1
    addiu $sp, $sp, -12
    sw    $ra, 8($sp)
    sw    $s0, 4($sp)
    sw    $s1, 0($sp)

    slti  $t0, $a0, 2       # $t0 = 1 neu n < 2
    beq   $t0, $zero, fr_rec

fr_base:                  
    move  $v0, $a0          # F(0) = 0, F(1) = 1
    j     fr_done

fr_rec:
    move  $s0, $a0          # $s0 = n
    addiu $a0, $s0, -1      # $a0 = n - 1
    jal   fib_rec           # $v0 = F(n - 1)
    move  $s1, $v0          # $s1 = F(n - 1)

    addiu $a0, $s0, -2      # $a0 = n - 2
    jal   fib_rec           # $v0 = F(n - 2)
    addu  $v0, $s1, $v0     # $v0 = F(n - 1) + F(n - 2)

fr_done:
    lw    $s1, 0($sp)
    lw    $s0, 4($sp)
    lw    $ra, 8($sp)
    addiu $sp, $sp, 12
    jr    $ra
fib_iter:
    move  $v0, $zero        # a = F(0)
    li    $t0, 1            # b = F(1)
    move  $t1, $zero        # i = 0
fi_loop:
    slt   $t2, $t1, $a0
    beq   $t2, $zero, fi_done
    addu  $t3, $v0, $t0     # a + b
    move  $v0, $t0
    move  $t0, $t3
    addiu $t1, $t1, 1
    j     fi_loop
fi_done:
    jr    $ra
