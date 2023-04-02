# this code reads 2 lines of input and prints 42
# change it to print the results of the recursive calculation

main:
	begin
	push	$ra

	move $t0, $a0
	move $t1, $a1

	la	$a0, line1
	la	$a1, 16
	li	$v0, 8		# fgets(line1, 80, stdin);
	syscall

	la	$a0, line2
	la	$a1, 16
	li	$v0, 8		# fgets(line1, 80, stdin);
	syscall

	li $a0, 0
	li $a1, 0
	jal function2 

	move $a0, $v0 
	li	$v0, 1
	syscall
	li	$a0, '\n'
	li	$v0, 11
	syscall

	li	$v0, 0		# return 0

	pop	$ra
	end

	jr	$ra



function2:
	begin
	push	$ra
	push 	$s0 
	push 	$s1 
	push 	$s2 
	push 	$s3
	push 	$s4 
	push 	$s5  

	move 	$s0, $a0 
	move 	$s1, $a1 

	mul	$s2, $s0, 1     
	la	$s3, line1   
	add	$s4, $s3, $s2 	
	lb	$s1, 0($s4)  

	beq $s1, '\n', return

	mul	$s2, $s0, 1     
	la	$s3, line1   
	add	$s4, $s3, $s2 	
	lb	$s5, 0($s4)

	beq $s5, '\n', return

	beq $s5, $s1, if_condition

	add $a0, $a0, 0
	add $a1, $a1, 1
	jal function2
	move $a0, $v0

	add $a0, $a0, 1
	sub $a1, $a1, 1
	jal function2 
	move $a1, $v0

	jal function3
	j end2 


if_condition:
	add $a0, $a0, 1 
	add $a0, $a1, 1 
	jal function2 
	add $v0, $v0, 1
	j end2 


return: 
	li $v0, 0
end2:
	pop 	$s5 
	pop 	$s4 
	pop 	$s3 
	pop 	$s2 
	pop 	$s1 
	pop 	$s0 
	pop 	$ra
	jr	$ra


function3:
	begin
	push	$ra
	push 	$s0 
	push 	$s1 

	move 	$s0, $a0 
	move 	$s1, $a1

	bge 	$s0, $s1, two 
	move 	$v0, $s1 
	j end1

two: 
	move 	$v0, $s0

end1:
	pop 	$s1 
	pop 	$s0 
	pop 	$ra

	jr	$ra


# Data for the lines fgets'd in main
	.data
line1:
	.byte 0:16

line2:
	.byte 0:16
