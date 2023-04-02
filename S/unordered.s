# Read 10 numbers into an array
# print 0 if they are in non-decreasing order
# print 1 otherwise

# i in register $t0

main:

    li   $t0, 0         # i = 0
loop0:
    bge  $t0, 10, end0  # while (i < 10) {

    li   $v0, 5         #   scanf("%d", &numbers[i]);
    syscall             #

    mul  $t1, $t0, 4    #   calculate &numbers[i]
    la   $t2, numbers   #
    add  $t3, $t1, $t2  #
    sw   $v0, ($t3)     #   store entered number in array

    addi $t0, $t0, 1    #   i++;
    j    loop0          # }
end0:
    
    li   $t0, 1        # i = 1;
    li   $t7, 0
loop1:
    bge $t0, 10, end  # while swapped isnt equal to 1 

    mul  $t1, $t0, 4    #   calculate &numbers[i]
    la   $t2, numbers   #
    add  $t3, $t1, $t2  #
    lw   $t6, ($t3)     #   load stored number in array

    sub  $t5, $t3, 4    # a = i -1
    lw   $t3, ($t5)  

    bge  $t6, $t3, increment

    li   $t7, 1

increment: 
    add $t0, $t0, 1
    j loop1

end:
    move $a0, $t7        # printf("%d", 0)
    li   $v0, 1         
    syscall

    li   $a0, '\n'      # printf("%c", '\n');
    li   $v0, 11
    syscall

    j end1

end1:

    jr   $ra

.data

numbers:
    .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  # int numbers[10] = {0};