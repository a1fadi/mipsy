# read 10 numbers into an array
# bubblesort them
# then print the 10 numbers

# i in register $t0
# registers $t1, $t2 & $t3 used to hold temporary results

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


    li $t5, 1            # store 1 into $t5 
sort:
    beq $t5, 0, swap_back #  go to swap_back
    li $t5, 0            #   $t5 = 0
    li $t0, 1            #   i = 1
loop1:
    bge $t0, 10, end1    #   while (i < 10) {

    mul $t1, $t0, 4      #
    la $t2, numbers      #
    add $t3, $t1, $t2    #      add the numbers
    lw $t6, ($t3)        #      store numbers into $t6

    sub $t4, $t3, 4      #      
    lw $t7, ($t4)        #      store subtracted numbers into $t7

    bge $t6, $t7, add_it   #      if (x < y) else go to add_it

    sw $t7, ($t3)        #        numbers[i] = y
    sw $t6, ($t4)        #        numbers[i - 1] = x
    li $t5, 1            #        swapped = 1
                         #      
add_it:
    add $t0, $t0, 1      # i=i+1
    b loop1              #   
end1:
    b sort               # 

swap_back:
    li $t0, 0           # i = 0
loop2:
    bge $t0, 10, end2   #  while (i < 10) {

    mul $t1, $t0, 4     #   calculate numbers
    la $t2, numbers     #
    add $t3, $t1, $t2   #
    lw $a0, ($t3)       #   
    li $v0, 1           #   print numbers
    syscall

    li   $a0, '\n'      #   print newline
    li   $v0, 11
    syscall

    add $t0, $t0, 1     #   i++
    b loop2             # }
end2:

    jr $31              # return

.data

numbers:
    .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  #loading into numbers[i]  