main:

    li   $s0, 12312


    move $a0, $s0 
    li   $v0, 1
    syscall            

    li   $a0, '\n'
    li   $v0, 11
    syscall

    jr    $ra 


