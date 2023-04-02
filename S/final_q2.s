# given one integer value return the right justified version of the value.
# right-justification is (in this case)
# the process of removing all zeros from the right side of the value
# eg:
# given  (in $a0) 0b00000000000000000000000001101000
# return (in $v0) 0b00000000000000000000000000001101

.text
.globl final_q2

final_q2:
    # YOU DO NOT NEED TO CHANGE THE LINES ABOVE HERE
    move $t0, $a0           #store argument into a temp register 
    beq $t0, 0, end         #if the number = 0 then return 0

loop_start:
    and $t1, $t0, 1         #bitwise and the argument with 1 
    bne $t1, 1, move        #if equal to 0, then shift right by one and repeat
    j end 

move:
    sra $t0, $t0, 1 
    j loop_start

end: 
    move    $v0, $t0    # return argument unchanged


    jr  $ra


# ADD ANY EXTRA FUNCTIONS BELOW THIS LINE
