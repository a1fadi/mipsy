main:
  
    li $a0, 5
    li $a1, 10

    jal abcd

    add $a2, $v1, 0 

    li $v0, 1
    syscall


    jr $ra


abcd:

    add $v1, $a0, $a1 
    
    jr $ra 

