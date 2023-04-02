# read 10 numbers into an array bubblesort them then print the 10 numbers

# i in register $t0, swapped in $t5, x in $t6, y in $t7
# registers $t1 - $t4 used to hold temporary results

main:

    li $t0, 0           # i = 0
loop0:
    bge $t0, 10, end0   # while (i < 10) {

    li $v0, 5           #   scanf("%d", &numbers[i]);
    syscall             #

    mul $t1, $t0, 4     #   calculate &numbers[i]
    la $t2, numbers     #
    add $t3, $t1, $t2   #
    sw $v0, ($t3)       #   store entered number in array

    add $t0, $t0, 1     #   i++;
    b loop0             # }
end0:

    li $t5, 1            # swapped = 1
sort:
    beq $t5, 0, end_sort # while (swapped) {
    li $t5, 0            #   swapped = 0
    li $t0, 1            #   i = 1
loop2:
    bge $t0, 10, end2    #   while (i < 10) {

    mul $t1, $t0, 4      #
    la $t2, numbers      #
    add $t3, $t1, $t2    #      $t3 = &numbers[i]
    lw $t6, ($t3)        #      y = numbers[i]

    sub $t4, $t3, 4      #      $t4 = &numbers[i - 1]
    lw $t7, ($t4)        #      x = numbers[i - 1]

    bge $t6, $t7, skip   #      if (x < y) {

    sw $t7, ($t3)        #        numbers[i] = y
    sw $t6, ($t4)        #        numbers[i - 1] = x
    li $t5, 1            #        swapped = 1
                         #      }
skip:
    add $t0, $t0, 1      #      i++;
    b loop2              #   }
end2:
    b sort               # }

end_sort:

    li $t0, 0           # i = 0
loop1:
    bge $t0, 10, end1   # while (i < 10) {

    mul $t1, $t0, 4     #   calculate &numbers[i]
    la $t2, numbers     #
    add $t3, $t1, $t2   #
    lw $a0, ($t3)       #   load numbers[i] into $a0
    li $v0, 1           #   printf("%d", numbers[i])
    syscall

    li   $a0, '\n'      #   printf("%c", '\n');
    li   $v0, 11
    syscall

    add $t0, $t0, 1     #   i++
    b loop1             # }
end1:

    jr $31              # return

.data

numbers:
    .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  # int numbers[10] = {0};