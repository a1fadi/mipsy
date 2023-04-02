YES = 1 

main: 
    begin 
    push    $ra 
    push    $s0 
    push    $s1 

    li   $s0, 0
    la   $a0, msg1
    li   $v0, 4
    syscall            # printf(Enter n: ")

    li    $v0, 5
    syscall 
    move  $s0, $v0

    li   $s1, 0
    la   $a0, msg2
    li   $v0, 4
    syscall            # printf(Enter n: ")

    li    $v0, 5
    syscall 
    move  $s1, $v0

    move  $a0, $s0 
    move  $a1, $s1 
    jal calculator 
    move $t0, $v0 

    move  $a0, $t0
    li    $v0, 1
    syscall            # printf ("%d", f)

    li   $a0, '\n'     # printf("%c", '\n');
    li   $v0, 11
    syscall

    move  $a0, $s0
    li    $v0, 1
    syscall            # printf ("%d", f)

    li   $a0, '\n'     # printf("%c", '\n');
    li   $v0, 11
    syscall


    pop     $s1
    pop     $s0 
    pop     $ra
    end

    jr $ra 

    .data
msg1:   .asciiz "Enter your first number: "
msg2:   .asciiz "Enter your second number: "
msg3:   .asciiz "Your calculated number is"

    .text 
calculator:
    begin 
    push    $ra 
    push    $s0 
    push    $s1 
    push    $s2 

    move $s0, $a0 
    move $s1, $a1 
    add $t0, $s0, YES 
    j calculator_end 

calculator_end:
    move $v0, $t0 

    pop $s2 
    pop $s1
    pop $s0 
    pop $ra 
    end 

    jr $ra 

