# Recursive factorial function
# n < 1 yields n! = 1
# $s0 is used for n
# we use an s register because the convention is their value
# is preserved across function calls
# f is in $t0

# DO NOT CHANGE THE CODE IN MAIN

main:
    begin 
    push    $ra 
    push    $s0 

    li   $s0, 0
    la   $a0, msg1
    li   $v0, 4
    syscall            # printf(Enter n: ")

    li    $v0, 5
    syscall            # scanf("%d", &n)
    move  $s0, $v0

    move  $a0, $s0     # factorial(n)
    jal   factorial    #
    move  $t0, $v0     #

    move  $a0, $s0
    li    $v0, 1
    syscall            # printf ("%d", n)

    la    $a0, msg2
    li    $v0, 4
    syscall            # printf("! = ")

    move  $a0, $t0
    li    $v0, 1
    syscall            # printf ("%d", f)

    li   $a0, '\n'     # printf("%c", '\n');
    li   $v0, 11
    syscall

                       # clean up stack frame
    pop    $s0 
    pop    $ra 
    end

    li  $v0, 0         # return 0
    jr  $ra

    .data
msg1:   .asciiz "Enter n: "
msg2:   .asciiz "! = "


# DO NOT CHANGE CODE ABOVE HERE


    .text
factorial:
    begin   
    push    $ra 
    push    $s0

    move $s0, $a0      # bring n into the function
    ble  $s0, 1, else  # if n is less than 1 go to else statement 
    sub  $a0, $s0, 1   # substitute 1 from n (n - 1) and then jump into the recursive function again
    jal  factorial     #
    mul  $t0, $v0, $s0 # once function has returned, multiply the result of function by N 
    j    end

else:                  # 
    li   $t0, 1        #   if n = 1, jump to the end because answer is 1
end:                   # 

    move $v0, $t0      # move the returned values from the function  

    pop    $s0 
    pop    $ra
    end

    jr  $ra
