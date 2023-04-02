# print a triangle of asterisks

main:
    li  $v0, 5         #   scanf("%d", &x);
    syscall
    move    $t0, $v0

    # YOU DO NOT NEED TO CHANGE THE LINES ABOVE HERE
    # CHANGE THE BELOW LINES TO YOUR CODE

    li $t1, 0           # i = 0 
loop_condition:    
    bge $t1, $t0, end   # while (i < x) {
loop1: 
li $t2, 0               # int j = 0;
loop2_cond: 
    bgt $t2, $t1, i_adder #  while (j <= i) {
loop2:
    li   $a0, '*'       #   printf("%c\n", '*');
    li   $v0, 11
    syscall

    add $t2, $t2, 1     # j = j + 1;
    j loop2_cond

i_adder:
add $t1, $t1, 1         #  i = i + 1;
    li   $a0, '\n'      #   printf("%c", '\n');
    li   $v0, 11
    syscall
    j loop_condition

    # CHANGE THE ABOVE LINES TO YOUR CODE
    # YOU DO NOT NEED TO CHANGE THE LINES BELOW HERE

end:
    li  $v0, 0         # return 0
    jr  $ra
