########################################################################
# COMP1521 22T1 -- Assignment 1 -- Mipstermind!
#
#
# !!! IMPORTANT !!!
# Before starting work on the assignment, make sure you set your tab-width to 8!
# It is also suggested to indent with tabs only.
# Instructions to configure your text editor can be found here:
#   https://cgi.cse.unsw.edu.au/~cs1521/22T1/resources/mips-editors.html
# !!! IMPORTANT !!!
#
#
# This program was written by Fadi Al Hatu(z5309136)
# on 28-03-22
#
# Version 1.0 (28-02-22): Team COMP1521 <cs1521@cse.unsw.edu.au>
#
########################################################################

#![tabsize(8)]

# Constant definitions.
# DO NOT CHANGE THESE DEFINITIONS

TURN_NORMAL = 0
TURN_WIN    = 1
NULL_GUESS  = -1


########################################################################
# .DATA
# YOU DO NOT NEED TO CHANGE THE DATA SECTION
.data

# int correct_solution[GUESS_LEN];
.align 2
correct_solution:	.space GUESS_LEN * 4

# int current_guess[GUESS_LEN];
.align 2
current_guess:		.space GUESS_LEN * 4

# int solution_temp[GUESS_LEN];
.align 2
solution_temp:		.space GUESS_LEN * 4


guess_length_str:	.asciiz "Guess length:\t"
valid_guesses_str:	.asciiz "Valid guesses:\t1-"
number_turns_str:	.asciiz "How many turns:\t"
enter_seed_str:		.asciiz "Enter a random seed: "
you_lost_str:		.asciiz "You lost! The secret codeword was: "
turn_str_1:		.asciiz "---[ Turn "
turn_str_2:		.asciiz " ]---\n"
enter_guess_str:	.asciiz "Enter your guess: "
you_win_str:		.asciiz "You win, congratulations!\n"
correct_place_str:	.asciiz "Correct guesses in correct place:   "
incorrect_place_str:	.asciiz "Correct guesses in incorrect place: "

############################################################
####                                                    ####
####   Your journey begins here, intrepid adventurer!   ####
####                                                    ####
############################################################


########################################################################
#
# Implement the following 8 functions,
# and check these boxes as you finish implementing each function
#
#  - [X] main
#  - [X] play_game
#  - [X] generate_solution
#  - [X] play_turn
#  - [X] read_guess
#  - [X] copy_solution_into_temp
#  - [X] calculate_correct_place
#  - [X] calculate_incorrect_place
#  - [X] seed_rand  (provided for you)
#  - [X] rand       (provided for you)
#
########################################################################


########################################################################
# .TEXT <main>
.text
main:
	# Args:     void
	# Returns:
	#   - $v0: int
	#
	# Frame:    [$fp, $ra]
	# Uses:     [$v0, $a0]
	# Clobbers: [$v0, $a0]
	#
	# Locals:
	#   - 'random_seed' in $v0
	#
	# Structure:
	#   main
	#   -> [prologue]
	#   -> main_body
	#   -> [epilogue]
	#   -> end
	#
	# Code: 
	# 	set up stack frame 
	# 	introduce game 
	# 	scan in random seed 
	# 	call game functions 
	#	take down stack frame 

main__prologue:
	begin                   # begin a new stack frame
	push	$ra             # | $ra

main__body:

	# printf("Guess length: %d\n", GUESS_LEN);

	li	$v0, 4          # syscall 4: print_string
	la	$a0, guess_length_str
	syscall                 # printf("Guess length: ");

	li	$v0, 1          # syscall 1: print_int
	li	$a0, GUESS_LEN
	syscall                 # printf("%d", GUESS_LEN);

	li	$v0, 11         # syscall 11: print_char
	li	$a0, '\n'
	syscall                 # printf("\n");


	# printf("Valid guesses: 1-%d\n", GUESS_CHOICES);

	li	$v0, 4          # syscall 4: print_string
	la	$a0, valid_guesses_str
	syscall                 # printf("Valid guesses: 1-");

	li	$v0, 1          # syscall 1: print_int
	li	$a0, GUESS_CHOICES
	syscall                 # printf("%d", GUESS_CHOICES);

	li	$v0, 11         # syscall 11: print_char
	li	$a0, '\n'
	syscall                 # printf("\n");


	# printf("How many turns: %d\n\n", MAX_TURNS);

	li	$v0, 4          # syscall 4: print_string
	la	$a0, number_turns_str
	syscall                 # printf("How many turns: ");

	li	$v0, 1          # syscall 1: print_int
	li	$a0, MAX_TURNS
	syscall                 # printf("%d", MAX_TURNS);

	li	$v0, 11         # syscall 11: print_char
	li	$a0, '\n'
	syscall                 # printf("\n");
	syscall                 # printf("\n");

	# printf("Enter a random seed: "):
	li	$v0, 4		#syscall 4: print_string 
	la	$a0, enter_seed_str
	syscall			#printf("Enter a random seed: "): 

	# scanf("%d", &random_seed);
	li	$v0, 5 		# syscall 5: scan_int		
	syscall			# scanf(%d, &random_seed)

	# move to seed_rand function to generate solution 
	move	$a0, $v0 	# load &random_seed into function 
	jal	seed_rand   	# seed_rand(random_seed)

	# start the game 
	jal	play_game	# play_game()

main__epilogue:

	# tear down stack frame 
	pop	$ra             # | $ra
	end                     # ends the current stack frame
end:
	# return 0 and exit function 
	li	$v0, 0		# return 0;
	jr	$ra             


########################################################################
# .TEXT <play_game>
.text
play_game:
	# Args:     void
	# Returns:  void
	#
	# Frame:    [$fp, $s0, $s1, $s2, $s3, $s4, $ra]
	# Uses:     [$s0, $s1, $s2, $s3, $s4, $v0, $a0, $t0, $t1]
	# Clobbers: [$a0, $v0]
	#
	# Locals:
	#   - 'turn' in $s0
	#   - 'turn_status' in $s1 
	#   - 'i' in $t0 
	#   - 'correct_solution[i]' in $t1 
	#   - other registers used to store addresses
	#
	#
	# Structure:
	#   play_game
	#   -> [prologue]
	#   -> play_game_body
	#   -> play_game_condition 
	#   -> play_game_loop 
	#   -> play_game_if 
	#   -> play_game_step 
	#   -> play_game_loss 
	#   -> play_game_loss_loop
	#   -> play_game_loss_condition
	#   -> play_game_loss_step
	#   -> play_game_end_pre
	#   -> play_game_end 
	#   -> play_game__epilogue
	#   -> [epilogue]
	#
	# Code: 
	#	Set up stack frame 
	#	generate the solution to the game 
	#	enters game loop calling other functions (until either win or limit exceeded)
	# 	if win then jump to win condition/statement
	# 	if lose jump to lose condition/statement
	# 	tear down stack 
	# 	return back


play_game__prologue:

	# start a new stack instance 
	begin
	push	$ra		#saving the return address to the stack 
	push	$s0		
	push	$s1 
	push	$s2 
	push	$s3
	push	$s4 		#push all used $s registers onto stack 

play_game__body:

	#generate the solution and initialise the turn counter 
	jal	generate_solution 	# generate_solution()

	#for (int turn = 0; turn < MAX_TURNS; turn++) {
	li	$s0, 0 			# int turn = 0

play_game_condition:

	#whilst turn is less than MAX_TURNS
	bge	$s0, MAX_TURNS, play_game_loss		#turn < MAX_TURNS

play_game_loop:

	#int turn_status = play_turn(turn);
	move	$a0, $s0 	#passing turn into play_turn variable 
	jal	play_turn 	#play_turn(turn);
	move	$s1, $v0 	#storing play_turn(turn) into a variable (turn_status)

play_game_if: 

	# if (turn_status == TURN_WIN) {
	beq	$s1, TURN_WIN, play_game_end 	#goto return;

play_game_step:

	# turn++
	add	$s0, $s0, 1
	j	play_game_condition 	#loop back 

play_game_loss:

	#if turn status never equals TURN_WIN 

	#int i = 0;
	li	$t0, 0 		#int i = 0 

	#printf("You lost! The secret codeword was: ");
	la	$a0, you_lost_str 
	li	$v0, 4 	
	syscall 	#printf("You lost! The secret codeword was: ");

play_game_loss_condition:

	#for (int i = 0; i < GUESS_LEN; i++) {
	bge	$t0, GUESS_LEN, play_game_end_pre

play_game_loss_loop: 


	mul	$s1, $t0, 4    	#load [i] 
	la	$s2, correct_solution   
	add	$s3, $s2, $s1 	#load address of correct_solution[i]
	lw	$t1, ($s3) 	#load correct_solution[i]

	#printf("%d ", correct_solution[i]);
	move	$a0, $t1 
	li	$v0, 1 	
	syscall 		#printf("%d ", correct_solution[i]);

	li	$a0, ' ' 
	li	$v0, 11 
	syscall 		#printf(" ");

play_game_loss_step:

	# i++
	add	$t0, $t0, 1	# i++
	j	play_game_loss_condition

play_game_end_pre:

	li	$v0, 11         # syscall 11: print_char
	li	$a0, '\n'
	syscall                 # printf("\n");

play_game_end:

	pop	$s4 
	pop	$s3
	pop	$s2 
	pop	$s1 
	pop	$s0 
	pop	$ra 
	end


play_game__epilogue:
	jr	$ra             # return;




########################################################################
# .TEXT <generate_solution>
.text
generate_solution:
	# Args:     void
	# Returns:  void
	#
	# Frame:    [$fp, $s0, $s1, $s2, $s3, $s4, $ra]
	# Uses:     [$t0, $s0, $s1, $s2, $s3, $s4]
	# Clobbers: [$a0, $v0]
	#
	# Locals:
	#   - 'i' in $s0 
	#   - 'GUESS_CHOICES' in $s1 
	#   - 'correct_solution[i]' in $t0  
	#   - other registers used to store addresses
	#
	# Structure:
	#   generate_solution
	#   -> [prologue]
	#   -> generate_solution_body
	#   -> generate_solution_condition 
	#   -> generate_solution_loop 
	#   -> generate_solution_step 
	#   -> generate_solution_end 
	#   -> [epilogue]
	#
	# Code: 
	#	set up stack frame 
	#	loop through and call rand until i > GUESS_LEN 
	# 	store result of rand into correct_solution[i]
	#	tear down stack 
	# 	return 


generate_solution__prologue:

	begin 		#saving the address of the stack pointer 
	push	$ra 
	push	$s0 
	push	$s1 
	push	$s2 
	push	$s3 
	push	$s4 	#saving addresses of all $s registers

generate_solution__body:

	# for (int i = 0; i < GUESS_LEN; i++) {
	li	$s0, 0 		# int i = 0 
 

generate_solution_condition:

	# i < GUESS_LEN
	bge	$s0, GUESS_LEN, generate_solution_end

generate_solution__loop:

	#correct_solution[i] = rand(GUESS_CHOICES) + 1;
	li	$s1, GUESS_CHOICES 	#storing GUESS_CHOICES into a register
	move	$a0, $s1 	#rand(GUESS_CHOICES)
	jal	rand
	add	$t0, $v0, 1	#rand(GUESS_CHOICES) + 1

	#load correct_solution[i] in order to store result of rand into it 
	mul	$s2, $s0, 4    	#load correct_solution[i] 
	la	$s3, correct_solution   
	add	$s4, $s3, $s2 	#load address 
	sw	$t0, 0($s4) 	#load rand(guess_choise) into address of correct_solution[i]

generate_solution_step:

	# i++
	add	$s0, $s0, 1 
	j 	generate_solution_condition 	#continue the loop 

generate_solution_end:

 
	pop	$s4 	#restore $s registers 
	pop	$s3 
	pop	$s2 
	pop	$s1 
	pop	$s0 
	pop	$ra 
	end 		#return stack pointer 

generate_solution__epilogue:

	jr	$ra             # return;




########################################################################
# .TEXT <play_turn>
.text
play_turn:
	# Args:
	#   - $a0: int
	# Returns:
	#   - $v0: int
	#
	# Frame:    [$fp, $s0, $s1, $s2, $s3, $s4, $ra]
	# Uses:     [$s0, $s1, $s2, $s3, $s4, $a0, $v0]
	# Clobbers: [$a0, $v0]
	#
	# Locals:
	#   - 'turn' in $s0 
	#   - 'turn + 1' in $s1 
	#   - 'correct_place' in $s1 
	#   - 'incorrect_place' in $s2 
	#   - 'TURN_NORMAL' in $s3 
	#   - 'TURN_WIN' in $s3  
	#   -  other registers used for memory addresses 
	#
	# Structure:
	#   play_turn
	#   -> [prologue]
	#   -> play_turn_text
	#   -> play_turn_continue
	#   -> play_turn_function_calls
	#   -> play_turn_continue 
	#   -> play_turn_win 
	#   -> play_turn_end 
	#   -> [epilogue]
	#
	# Code: 
	#	Build up stack 
	#   	Print all the different statements regarding turns
	# 	Scan in the guess 
	# 	Call all functions to see how 'correct it is' 
	# 	Return to the user if they won or lost or need to continue 
	# 	Tear down stack 
	# 	Return 


play_turn_prologue:
	begin 		#Store stack pointer address
	push	$ra 
	push	$s0 
	push	$s1 
	push	$s2 
	push	$s3	#store $s registers onto stack 

play_turn_text:

	#printf("---[ Turn %d ]---\n", turn + 1);
	move	$s0, $a0 	
	add	$s1, $s0, 1 	#turn + 1

	li	$v0, 4	
	la	$a0, turn_str_1 #printf("---[ Turn
	syscall			

	move	$a0, $s1
	li 	$v0, 1 
	syscall			#printf("%d", turn + 1)

	li	$v0, 4
	la	$a0, turn_str_2
	syscall 		#printf("]---\n")

	li	$v0, 4		
	la	$a0, enter_guess_str
	syscall 		#printf("Enter your guess: ");


play_turn_function_calls:

	jal	read_guess	#read_guess();	

	jal	copy_solution_into_temp	   #copy_solution_into_temp();	

	jal	calculate_correct_place    #calculate_correct_place();
	move	$s1, $v0 		   #int correct_place   = calculate_correct_place();

	jal	calculate_incorrect_place  #calculate_incorrect_place();
	move	$s2, $v0 		   #int incorrect_place = calculate_incorrect_place();

	# if (correct_place == GUESS_LEN) {
	beq	$s1, GUESS_LEN, play_turn_win		

play_turn_continue: 

	#printf("Correct guesses in correct place:   %d\n", correct_place);
	li	$v0, 4
	la	$a0, correct_place_str
	syscall 	#printf("Correct guesses in correct place:

	move	$a0, $s1 	#printf("%d\n", correct_place);
	li	$v0, 1
	syscall 	

	li	$v0, 11         # syscall 11: print_char
	li	$a0, '\n'
	syscall                 # printf("\n");


	#printf("Correct guesses in incorrect place: %d\n", incorrect_place);
	li	$v0, 4	
	la	$a0, incorrect_place_str
	syscall 		#printf("Correct guesses in incorrect place:

	move	$a0, $s2 
	li	$v0, 1		
	syscall 		# printf("%d\n", incorrect_place);

	li	$v0, 11         # syscall 11: print_char
	li	$a0, '\n'
	syscall                 # printf("\n");

	li	$s3, TURN_NORMAL 	
	move	$v0, $s3		#return TURN_NORMAL
	j	play_turn_end 

play_turn_win:

	# printf("You win, congratulations!\n");
	li	$v0, 4
	la	$a0, you_win_str 
	syscall 

	# Return 'TURN_WIN' 
	li	$s3, TURN_WIN 
	move	$v0, $s3     	#return TURN_WIN;
	j	play_turn_end 

play_turn_end:

	pop	$s3 	#return all $s registers from stack 
	pop	$s2 
	pop	$s1
	pop	$s0 
	pop	$ra
	end		#return stack pointer 

play_turn__epilogue:
	jr	$ra             # return;



########################################################################
# .TEXT <read_guess>
.text
read_guess:
	# Args:     void
	# Returns:  void
	#
	# Frame:    [$fp, $s0, $s1, $s2, $s3, $s4, $ra]
	# Uses:     [$s0, $s1, $s2, $s3, $s4, $v0]
	# Clobbers: [$v0]
	#
	# Locals:
	#   - 'n_guess' as $s0 
	#   - 'guess' as $s1 
	#   - 'current_guess[n_guess]' as $s1 
	#   -  other registers used for memory addresses 
	#
	# Structure:
	#   read_guess
	#   -> [prologue]
	#   -> read_guess_body
	#   -> read_guess_condition 
	#   -> read_guess_loop 
	#   -> read_guess_step 
	#   -> read_guess_end 
	#   -> [epilogue]
	#
	# Code: 
	# 	Load the stack 
	# 	Read each individual guess and store it into the array 
	# 	Loop through and continue till all guesses have been read 
	# 	restore the stack 

read_guess__prologue:

	begin		#load stack pointer 
	push	$ra 
	push	$s0 
	push	$s1
	push	$s2 
	push	$s3
	push	$s4  	#load all S registers onto the stack 

read_guess__body: 	

	li	$s0, 0 		# int n_guess = 0

read_guess_condition: 

	# for (int n_guess = 0; n_guess < GUESS_LEN; n_guess++)
	bge	$s0, GUESS_LEN, read_guess_end 		# n_guess < GUESS_LEN

read_guess_loop: 

	li	$s1, 0 		#int guess = 0

	li	$v0, 5 
	syscall
	move	$s1, $v0 	#scanf("%d", &guess);

	mul	$s2, $s0, 4     #load current_guess[n_guess] 
	la	$s3, current_guess   
	add	$s4, $s3, $s2 	#load address 
	sw	$s1, 0($s4) 	#store guess into address of current_guess[n_guess]


read_guess_step:
	add	$s0, $s0, 1 	#n_guess++
	j	read_guess_condition 	#continue the loop 

read_guess_end: 

	pop	$s4  	#restore the $s registers of the stack 
	pop	$s3 
	pop	$s2 
	pop	$s1
	pop	$s0
	pop	$ra 	#restore the stack pointer 
	end

read_guess__epilogue:

	jr	$ra             # return;


########################################################################
# .TEXT <copy_solution_into_temp>
.text
copy_solution_into_temp:
	# Args:     void
	# Returns:  void
	#
	# Frame:    [$fp, $s0, $s1, $s2, $s3, $s4, $s5 $ra]
	# Uses:     [$s0, $s1, $s2, $s3, $s4, $s5, $v0]
	# Clobbers: [$v0]
	#
	# Locals:
	#   - 'i' in $s0 
	#   - 'solution_temp[i]' in $s5 
	#   - 'correct_solution[i]' in $s5 
	#   -  other registers used for memory addresses 
	#
	# Structure:
	#   copy_solution_into_temp
	#   -> [prologue]
	#   -> body
	#   -> [epilogue]
	#
	# Code:
	# 	Set up stack 
	# 	set i and find address of the correct solution
	# 	store whats set at that location into solution_temp at same index ('i') 
	# 	restore the stack 

copy_solution_into_temp__prologue:

	begin 		#set stack pointer 
	push	$ra 
	push	$s0 
	push	$s1
	push	$s2 
	push	$s3
	push	$s4
	push	$s5 	#store all s registers onto stack 

copy_solution_into_temp__body:

	#for (int i = 0; i < GUESS_LEN; i++) {
	li	$s0, 0 		# i = 0 

copy_solution_into_temp__loop:

	bge	$s0, GUESS_LEN, copy_solution_into_temp__end 	#i < GUESS_LEN

	#load the correct solution array to load into solution temp array at the same index 

	mul	$s1, $s0, 4    	#load correct_solution[i] 
	la	$s3, correct_solution   
	add	$s4, $s3, $s1 	#load address 
	lw	$s5, 0($s4) 	#load correct number into register from correct_solution[i]

	#store whats located in correct_solution into solution_temp

	mul	$s1, $s0, 4    	#load solution_temp[i] 
	la	$s3, solution_temp   
	add	$s4, $s3, $s1 	#load address 
	sw	$s5, 0($s4) 	#store correct solution number at i into solution_temp[i] 


copy_solution_into_temp__step:

	add	$s0, $s0, 1	#i++
	j	copy_solution_into_temp__loop


copy_solution_into_temp__end:

	pop	$s5 	#restore all $s registers 
	pop	$s4 
	pop	$s3 
	pop	$s2 
	pop	$s1
	pop	$s0 
	pop	$ra 
	end		#restore stack pointer 

copy_solution_into_temp__epilogue:
	jr	$ra     # return;


########################################################################
# .TEXT <calculate_correct_place>
.text
calculate_correct_place:
	# Args:     void
	# Returns:
	#   - $v0: int
	#
	# Frame:    [$fp, $s0, $s1, $s2, $s3, $s4, $s5, $s6, $s7 $ra]
	# Uses:     [$s0, $s1, $s2, $s3, $s4, $s5, $s6, $s7, $t0 $v0]
	# Clobbers: [$v0]
	#
	# Locals:
	#   - 'total' in $s0 
	#   - 'guess_index' in $s1 
	#   - 'guess' in $s5
	#   - 'solution_temp[guess_index]' in $s7 
	#   - 'NULL_GUESS' in $t0 
	#   -  other registers used for memory addresses 
	#
	# Structure:
	#   calculate_correct_place
	#   -> [prologue]
	#   -> calculate_correct_place__body
	#   -> calculate_correct_condition 
	#   -> calculate_correct_loop 
	#   -> calculate_loop_if
	#   -> calculate_correct_totalstep
	#   -> calculate_correct_null
	#   -> calculate_correct_step 
	#   -> calculate_correct_place_end
	#   -> [epilogue]
	#
	# Code:
	# 	load registers onto stack 
	# 	calculate guess at guess index 
	# 	calculate solution at guess index 
	# 	if both are equal then increase the total by one 
	#	if equal make the guess NULL 
	# 	return total 
	# 	deconstruct the stack 

calculate_correct_place__prologue:
	begin 		#set the stack pointer 
	push	$ra 
	push	$s0 
	push	$s1
	push	$s2
	push	$s3 
	push	$s4 
	push	$s5
	push	$s6 
	push	$s7 	#push all $s registers onto the stack  

calculate_correct_place__body:

	#int total = 0;
	li	$s0, 0 	#total = 0 

	#int guess_index = 0
	li	$s1, 0	#guess_index = 0

calculate_correct_condition:

	#for (int guess_index = 0; guess_index < GUESS_LEN; guess_index++) {
	bge	$s1, GUESS_LEN, calculate_correct_place_end	#guess_index < GUESS_LEN

calculate_correct_loop: 

	#calculate whats stored at current_guess[guess_index] 

	mul	$s2, $s1, 4    	#load current_guess[guess_index] 
	la	$s3, current_guess   
	add	$s4, $s3, $s2 	#load address of current guess 
	lw	$s5, 0($s4) 	#load guess at address of current_guess[guess_index]

	#calculate whats stored at solution_temp[index]
	mul	$s2, $s1, 4    #load solution_temp[guess_index] 
	la	$s3, solution_temp   
	add	$s6, $s3, $s2 	#load address 
	lw	$s7, 0($s6) 	#load integer stored at address of solution_temp[guess_index]


calculate_loop_if:

	#if (solution_temp[guess_index] == guess) {
	beq	$s5, $s7, calculate_correct_totalstep  
	j	calculate_correct_step

calculate_correct_totalstep:

	# total++;
	add	$s0, $s0, 1

calculate_correct_null:

	#current_guess[guess_index] = NULL_GUESS;
	#solution_temp[guess_index] = NULL_GUESS;

	li	$t0, NULL_GUESS		#NULL_GUESS into a register 

	mul	$s2, $s1, 4    	#load current_guess[guess_index] 
	la	$s3, current_guess   
	add	$s4, $s3, $s2 	#load address 
	sw	$t0, ($s4) 	#store NULL_GUESS into address of current_guess[guess_index]

	#calculate whats stored at solution_temp[index]
	mul	$s2, $s1, 4   	 #load solution_temp[guess_index] 
	la	$s3, solution_temp   
	add	$s6, $s3, $s2 	#load address 
	sw	$t0, ($s6) 	#store NULL_GUESS into address of solution_temp[guess_index]

calculate_correct_step:

	#proceed to compare the next guess 
	add	$s1, $s1, 1 	#guess_index++
	j	calculate_correct_condition

calculate_correct_place_end:
	
	#return total;
	move	$v0, $s0
   
	pop	$s7 	#restore the $s registers from the stack 
	pop	$s6 
	pop	$s5 
	pop	$s4 
	pop	$s3 
	pop	$s2 
	pop	$s1
	pop	$s0 
	pop	$ra 
	end		#restore the stack 

calculate_correct_place__epilogue:
	jr	$ra     # return;


########################################################################
# .TEXT <calculate_incorrect_place>
.text
calculate_incorrect_place:
		# Args:     void
	# Returns:
	#   - $v0: int
	#
	# Frame:    [$fp, $s0, $s1, $s2, $s3, $s4, $s5, $s6, $s7 $ra]
	# Uses:     [$s0, $s1, $s2, $s3, $s4, $s5, $s6, $s7, $t0 $v0]
	# Clobbers: [$v0]
	#
	# Locals:
	#   - 'total' in $s0 
	#   - 'guess_index' in $s1 
	#   - 'solution_index' in $s2 
	#   - 'guess' in $s7
	#   - 'solution_temp[solution_index]' in $s6 & $s5
	#   - 'NULL_GUESS' in $t0 
	#   -  other registers used for memory addresses 
	#
	# Structure:
	#   calculate_correct_place
	#   -> [prologue]
	#   -> calculate_incorrect_place__body:
	#   -> calculate_incorrect_place_condition:
	#   -> calculate_incorrect_place_loop:
	#   -> calculate_incorrect_place_if:
	#   -> calculate_incorrect_place_body2:
	#   -> calculate_incorrect_place_cond2:
	#   -> calculate_incorrect_place_loop2:
	#   -> calculate_incorrect_place_if2:
	#   -> calculate_incorrect_place_step2:
	#   -> calculate_incorrect_step:
	#   -> calculate_incorrect_place_end:
	#   -> [epilogue]
	#
	# Code:
	# 	load registers onto stack 
	# 	calculate guess at guess index 
	# 	if it doesn't equal to NULL_GUESS (i.e guess was in the correct position already)
	#	enter a second loop, looping through the solution array using a new index 
	# 	if 'guess' at any point of the solution array is equal to a number in the solution  then total ++
	# 	then once the first number of 'guess' has been compared, move onto the next and reset solution index  
	#	if equal make the number at soluion_index NULL so its not counted twice
	# 	return total 
	# 	deconstruct the stack 

calculate_incorrect_place__prologue:
	begin		#load the stack pointer 
	push	$ra 
	push	$s0 
	push	$s1 
	push	$s2 
	push	$s3 
	push	$s4 
	push	$s5 
	push	$s6 
	push	$s7 	#load all $s registers onto the stack 

calculate_incorrect_place__body:

	#int total = 0
	li	$s0, 0 		# int total = 0  

	#int guess_index = 0
	li	$s1, 0 	 	# int guess index = 0

calculate_incorrect_place_condition:

	#for (int guess_index = 0; guess_index < GUESS_LEN; guess_index++) {
	bge	$s1, GUESS_LEN, calculate_incorrect_place__end		#guess_index < GUESS_LEN

calculate_incorrect_place_loop:

	mul	$s2, $s1, 4     #load current_guess[guess_index] 
	la	$s3, current_guess   
	add	$s4, $s3, $s2 	#load address 
	lw	$s7, ($s4) 	#load guess at address of current_guess[guess_index]

	#calculate whats stored at solution_temp[index]
	mul	$s2, $s1, 4     #load solution_temp[guess_index] 
	la	$s3, solution_temp   
	add	$s4, $s3, $s2 	#load address 
	lw	$s5, ($s4) 	#load integer at address of solution_temp[guess_index]


calculate_incorrect_place_if:

	#if (guess != NULL_GUESS) {
	beq	$s7, NULL_GUESS, calculate_incorrect_step 

calculate_incorrect_place_body2:

	#int solution_index = 0
	li	$s2, 0  	#solution_index = 0

calculate_incorrect_place_cond2:

	#for (int solution_index = 0; solution_index < GUESS_LEN; solution_index++) {
	bge	$s2, GUESS_LEN, calculate_incorrect_step    #solution_index < GUESS_LEN

calculate_incorrect_place_loop2:

	mul	$s3, $s2, 4    #load solution_temp[solution_index] 
	la	$s4, solution_temp   
	add	$s5, $s4, $s3  #load address 
	lw	$s6, ($s5)     #load integer at address of solution_temp[solution_index]

calculate_incorrect_place_if2:

	#Load NULL_GUESS into a register 
	li	$t0, NULL_GUESS  

	#if (solution_temp[solution_index] == guess) {
	bne	$s6, $s7, calculate_incorrect_place_step2

	#total++;
	add	$s0, $s0, 1 

	# Store NULL_GUESS at the address of the 'matching' solution 
	# Solution_temp[solution_index] = NULL_GUESS;
	mul	$s3, $s2, 4    	#load solution_temp[solution_index] 
	la	$s4, solution_temp #solution_temp   
	add	$s5, $s4, $s3 	#load address 
	sw	$t0, ($s5) 	#store NULL_GUESS into address of solution_temp[solution_index]

	#break;	
	j	calculate_incorrect_step 



calculate_incorrect_place_step2:

	#solution_index++
	add	$s2, $s2, 1
	j	calculate_incorrect_place_cond2

calculate_incorrect_step:

	#move onto the next integer in the guess array
	li	$s2, 0 		#solution_index = 0
	add	$s1, $s1, 1 	#guess_index++
	j	calculate_incorrect_place_condition

calculate_incorrect_place__end:

	move	$v0, $s0	#return total 

	pop	$s7 	#restore the $s registers on the stack 
	pop	$s6 
	pop	$s5 
	pop	$s4 
	pop	$s3 
	pop	$s2 
	pop	$s1 
	pop	$s0
	pop	$ra 
	end 		#return the stack pointer 

calculate_incorrect_place__epilogue:
	jr	$ra             # return;


########################################################################
####                                                                ####
####        STOP HERE ... YOU HAVE COMPLETED THE ASSIGNMENT!        ####
####                                                                ####
########################################################################

##
## The following are two utility functions, provided for you.
##
## You don't need to modify any of the following.
## But you may find it useful to read through.
## You'll be calling these functions from your code.
##


########################################################################
# .DATA
# DO NOT CHANGE THIS DATA SECTION
.data

# int random_seed;
.align 2
random_seed:		.space 4


########################################################################
# .TEXT <seed_rand>
# DO NOT CHANGE THIS FUNCTION
.text
seed_rand:
	# Args:
	#   - $a0: unsigned int seed
	# Returns: void
	#
	# Frame:    []
	# Uses:     [$a0, $t0]
	# Clobbers: [$t0]
	#
	# Locals:
	# - $t0: offline_seed
	#
	# Structure:
	#   seed_rand

	li	$t0, OFFLINE_SEED # const unsigned int offline_seed = OFFLINE_SEED;
	xor	$t0, $a0          # random_seed = seed ^ offline_seed;
	sw	$t0, random_seed

	jr	$ra               # return;




########################################################################
# .TEXT <rand>
# DO NOT CHANGE THIS FUNCTION
.text
rand:
	# Args:
	#   - $a0: unsigned int n
	# Returns:
	#   - $v0: int
	#
	# Frame:    []
	# Uses:     [$a0, $v0, $t0]
	# Clobbers: [$v0, $t0]
	#
	# Locals:
	# - $t0: random_seed
	#
	# Structure:
	#   rand

	lw	$t0, random_seed  # unsigned int rand = random_seed;
	multu	$t0, 0x5bd1e995   # rand *= 0x5bd1e995;
	mflo	$t0
	addiu	$t0, 12345        # rand += 12345;
	sw	$t0, random_seed  # random_seed = rand;

	remu	$v0, $t0, $a0     # rand % n
	jr	$ra               # return;
