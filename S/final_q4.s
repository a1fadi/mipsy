# return the number of peaks in an array of integers
#
# A peak is a value that is both preceded and succeeded
# by a value smaller than itself
#
# ie:
# Both the value before and the value after the current value
# are smaller than the current value
#
# eg:
# [1, 3, 2, 5, 4, 4, 9, 0, 1, -9, -5, -7]
#     ^     ^        ^     ^       ^
# The value 3, 5, 9, 1, -5 are all peaks in this array
# So your function should return 5

.text
.globl final_q4

final_q4:
	move	$t0, $a0	# array
	move	$t1, $a1	# length

	li $t2, 0   		#total 
	li $t3, 1			# i = 1

	sub $t1, $t1, 1
loop_cond:
	bge $t3, $t1, end 

loop:
	mul	$t4, $t3, 4    	#load values in array[i]
	la	$t5, ($t0) 
	add	$t4, $t5, $t4 	
	lw	$t6, ($t4) 	

	sub $t3, $t3, 1

	mul	$t4, $t3, 4    	#load values in arrays[i-1]
	la	$t5, ($t0) 
	add	$t4, $t5, $t4 	
	lw	$t7, ($t4) 	

	add $t3, $t3, 1

	ble $t6, $t7, loop_iter #first if statement

	mul	$t4, $t3, 4    	#load values in array[i]
	la	$t5, ($t0) 
	add	$t4, $t5, $t4 	
	lw	$t6, ($t4) 	

	add $t3, $t3, 1

	mul	$t4, $t3, 4    	#load values in arrays[1+1]
	la	$t5, ($t0) 
	add	$t4, $t5, $t4 	
	lw	$t7, ($t4)

	sub $t3, $t3, 1

	ble $t6, $t7, loop_iter #first if statement
	add $t2, $t2, 1


loop_iter:
	add $t3, $t3, 1
	j loop_cond
	

end:
	move $v0, $t2
	jr	$ra


