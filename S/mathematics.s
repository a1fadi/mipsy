.data
    prompt_str: .asciiz "Enter a random seed: "
    result_str: .asciiz "The random result is: "

.text
main:
    addi $sp, $sp, -8  # create stack frame
    sw   $ra, 4($sp)   # save the return address 
    sw   $s0, 0($sp)   # save the first $s0 

    la   $a0, prompt_str
    li   $v0, 4
    syscall            # printf(Enter a random seed: ")

    li    $v0, 5
    syscall            # scanf("%d", &random_seed)
    move  $s0, $v0

    move $a0, $s0
    jal seed_rand

    

    

    # ADD CODE FORFUNCTION HERE

    lw   $s0, 0($sp)   # restoring all stack pointers ($s0, $ra, $sp)
    lw   $ra, 4($sp)   
    addi $sp, $sp, 8   

    li  $v0, 0         # returning 0
    jr  $ra

##
## The following are two utility functions, provided for you.
##
## You don't need to modify any of the following.
## But you may find it useful to read through.
## You'll be calling these functions from your code.
##

OFFLINE_SEED = 0x7F10FB5B

########################################################################
# .DATA
.data

# int random_seed;
.align 2
random_seed:    .space 4


########################################################################
# .TEXT <seed_rand>
.text

# DO NOT CHANGE THIS FUNCTION

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

    li  $t0, OFFLINE_SEED # const unsigned int offline_seed = OFFLINE_SEED;
    xor $t0, $a0          # random_seed = seed ^ offline_seed;
    sw  $t0, random_seed

    jr  $ra               # return;

########################################################################
# .TEXT <rand>
.text

# DO NOT CHANGE THIS FUNCTION

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
    #   - $t0: random_seed
    #
    # Structure:
    #   rand

    lw      $t0, random_seed # unsigned int rand = random_seed;
    multu   $t0, 0x5bd1e995  # rand *= 0x5bd1e995;
    mflo    $t0
    addiu   $t0, 12345       # rand += 12345;
    sw      $t0, random_seed # random_seed = rand;

    remu    $v0, $t0, $a0    #    rand % n
    jr      $ra              # return rand % n;