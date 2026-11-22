.data
s1:     .asciiz "kien truc may tinh"
s2:     .asciiz "mips"
s3:     .asciiz ""
s4:     .asciiz "a bc def"
s5:     .asciiz "goi long nhau phai luu thanh ghi ra"
bar:    .asciiz "|"
nl:     .asciiz "\n"

.text
main:
        la    $a0, s5
        jal   reverse_words

        li    $v0, 4
        la    $a0, bar
        syscall
        la    $a0, s5
        syscall
        la    $a0, bar
        syscall
        la    $a0, nl
        syscall

        li    $v0, 10
        syscall

strlen:
        move  $t0, $a0
strlen_loop:
        lbu   $t1, 0($t0)
        beq   $t1, $zero, strlen_done
        addiu $t0, $t0, 1
        j     strlen_loop
strlen_done:
        subu  $v0, $t0, $a0
        jr    $ra

rev_range:
        sltu  $t0, $a0, $a1
        beq   $t0, $zero, rev_done
rev_loop:
        lbu   $t0, 0($a0)
        lbu   $t1, 0($a1)
        sb    $t1, 0($a0)
        sb    $t0, 0($a1)
        addiu $a0, $a0, 1
        addiu $a1, $a1, -1
        sltu  $t0, $a0, $a1
        bne   $t0, $zero, rev_loop
rev_done:
        jr    $ra

reverse_words:
        addi  $sp, $sp, -16
        sw    $ra, 12($sp)
        sw    $s0, 8($sp)
        sw    $s1, 4($sp)
        sw    $s2, 0($sp)

        move  $s0, $a0
        jal   strlen
        sltiu $t0, $v0, 2
        bne   $t0, $zero, rw_done

        move  $s1, $s0
        move  $s2, $s0
        addu  $s0, $s0, $v0

        move  $a0, $s1
        addiu $a1, $s0, -1
        jal   rev_range

rw_loop:
        sltu  $t0, $s1, $s0
        beq   $t0, $zero, rw_last_word
        lbu   $t1, 0($s1)
        li    $t2, 32
        beq   $t1, $t2, rw_space
        addiu $s1, $s1, 1
        j     rw_loop

rw_space:
        move  $a0, $s2
        addiu $a1, $s1, -1
        jal   rev_range
        addiu $s1, $s1, 1
        move  $s2, $s1
        j     rw_loop

rw_last_word:
        move  $a0, $s2
        addiu $a1, $s1, -1
        jal   rev_range

rw_done:
        lw    $s2, 0($sp)
        lw    $s1, 4($sp)
        lw    $s0, 8($sp)
        lw    $ra, 12($sp)
        addi  $sp, $sp, 16
        jr    $ra