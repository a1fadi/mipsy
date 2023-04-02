# Call the `final_q2()' function from the command-line.
# See the exam paper and `final_q2.s' file for a description of the question.

# Do not change this file.

.data

usage_start:  .asciiz "Usage: "
usage_end:    .asciiz " <value>\n"
answer_start: .asciiz "final_q2("
answer_end:   .asciiz ") returned "

.text
.globl main

main:
    addiu $sp, $sp, -8
    sw    $s0, 0($sp)
    sw    $ra, 4($sp)

    bne   $a0, 2, main__print_usage
    b     main__call_final_q2

main__print_usage:

    # printf("Usage %s <value>\n", argv[0]);
    li    $v0, 4
    la    $a0, usage_start
    syscall

    li    $v0, 4
    lw    $a0, ($a1)
    syscall

    li    $v0, 4
    la    $a0, usage_end
    syscall

    li    $v0, 1

    b     main__end

main__call_final_q2:

    # printf("final_q2(%d) returned %d\n", value, final_q2(value));
    li    $v0, 4
    la    $a0, answer_start
    syscall

    lw    $a0, 4($a1)
    jal   atoi
    move  $s0, $v0
    move  $a0, $s0
    li    $v0, 1
    syscall

    li    $v0, 4
    la    $a0, answer_end
    syscall

    move  $a0, $s0
    jal   final_q2
    move  $t0, $v0

    li    $v0, 1
    move  $a0, $t0
    syscall

    li    $v0, 11
    li    $a0, '\n'
    syscall

    li    $v0, 0

main__end:
    lw    $ra, 4($sp)
    lw    $s0, 0($sp)
    addiu $sp, $sp, 8

    # return
    jr    $ra


atoi:
    li   $v0, 0
    li   $t0, 0
atoi__digit_loop_start:
    add  $t1, $a0, $t0
    lb   $t1, ($t1)
    beqz $t1, atoi__digit_loop_end
    mul  $v0, $v0, 10
    addi $t1, $t1, -48
    add  $v0, $v0, $t1
    addi $t0, $t0, 1
    b    atoi__digit_loop_start
atoi__digit_loop_end:
    jr   $ra
