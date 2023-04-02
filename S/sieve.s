# Sieve of Eratosthenes
# https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes
main:
    li  $t0, 0              # i = 0

loop0: 
    bge $t0, 1000, end0     #whilst i is less than 1000
    la $t1, prime           #find the address of prime 
    add $t2, $t1, $t0       #gives the address + i 
    li $t3, 1               # load the integer 1 into t4 to put it back in the array 
    sb $t3, ($t2)           # load 1 into the address of the array + i offset

    add $t0, $t0, 1         #increment i 
    j loop0

end0: 
    li $t0, 2

loop1:
    bge $t0, 1000, end      #whilst i is less than 1000, continue the loop 
    la $t1, prime            #find the starting address of prime 
    add $t2, $t1, $t0 
    lb $t3, ($t2)            #load the value at the address $t2 into $t3 
    bne $t3, 1, end1         # if $t3 isnt equal to 1, then jump to the end

    move $a0, $t0            #print the value of i 
    li $v0, 1
    syscall                

    li $a0, '\n'             #print the new line
    li $v0, 11 
    syscall

    mul $t4, $t0, 2          #int j = i*2 


loop2: 
    bge $t4, 1000, end1      #loop through checking J 
    la  $t1, prime                     
    add $t2, $t1, $t4 
    li $t3, 0 
    sb $t3, ($t2)

    add $t4, $t4, $t0  
    j loop2 


end1: 
    add $t0, $t0, 1         #increment i 
    j loop1 


end:
    li $v0, 0           # return 0
    jr $31


.data
prime:
    .space 1000