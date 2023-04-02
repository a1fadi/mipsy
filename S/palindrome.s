# read a line and print whether it is a palindrom

main:
    la   $a0, str0       # printf("Enter a line of input: ");
    li   $v0, 4
    syscall

    la   $a0, line
    la   $a1, 256
    li   $v0, 8          # fgets(buffer, 256, stdin)
    syscall              #

    calculator: 

    li  $t0, 0

    calculator_condition:

    mul $t1, $t0, 1
    la  $t2, line 
    add $t3, $t2, $t1 
    lb  $t4, ($t3)

    beq $t4, 0, palindrome_body 

calculator_step:

    add $t0, $t0, 1
    j calculator_condition

palindrome_body:

    li  $t1, 0  #j = 0 
    sub $t2, $t0, 2 

palindrome_condition:

    bge $t1, $t2, palindrome_end

palindrome_loop:

    mul $s1, $t1, 1
    la  $s2, line 
    add $s3, $s2, $s1 
    lb  $s4, ($s3)

    mul $s1, $t2, 1
    la  $s2, line 
    add $s3, $s2, $s1 
    lb  $s5, ($s3)

    bne $s5, $s4, not_palindrome_end

not_palindrome_step:

    add $t1, $t1, 1
    sub $t2, $t2, 1  
    j palindrome_condition

not_palindrome_end:
    la   $a0, not_palindrome
    li   $v0, 4
    syscall
    j end 

palindrome_end:
    la   $a0, palindrome
    li   $v0, 4
    syscall

end:
    li   $v0, 0          # return 0
    jr   $ra


.data
str0:
    .asciiz "Enter a line of input: "
palindrome:
    .asciiz "palindrome\n"
not_palindrome:
    .asciiz "not palindrome\n"


# line of input stored here
line:
    .space 256

