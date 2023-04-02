main:
la $a0, string0 #printf("Enter a number: ");
li $v0, 4 
syscall

li $v0, 5 #scanf("%d", x)
syscall

move $t0, $v0

blt $t0, 50, fail
blt $t0, 65, pass
blt $t0, 75, credit
blt $t0, 85, Distinction

j Hidistinction

fail:
la $a0, fail1 
li $v0, 4

syscall
j end

pass:
la $a0, pass1 
li $v0, 4

syscall
j end

credit:
la $a0, credit1 
li $v0, 4

syscall
j end

Distinction:
la $a0, Distinction1 
li $v0, 4

syscall
j end

Hidistinction:
la $a0, Hidistinction1 
li $v0, 4

syscall
j end


end:
	li $v0, 0
	jr $ra

.data

string0:
	.asciiz "Enter a mark: "
fail1:
	.asciiz "FL\n"
pass1:
	.asciiz "PS\n"
credit1:
	.asciiz "CR\n"
Distinction1: 
	.asciiz "DN\n"
Hidistinction1:
	.asciiz "HD\n"

