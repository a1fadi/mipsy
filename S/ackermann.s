.text
main:
    # ADD CODE TO CREATE STACK FRAME

    # ADD CODE FORFUNCTION HERE

    # ADD CODE TO REMOVE STACK FRAME
    jr $ra


.data
    prompt_m:    .asciiz "Enter m: "
    prompt_n:    .asciiz "Enter n: "
    msg1:        .asciiz "Ackermann("
    msg2:        .asciiz ", "
    msg3:        .asciiz ") = "


.text
ackermann:
    # ADD CODE TO CREATE STACK FRAME

    # ADD CODE FORFUNCTION HERE

    # ADD CODE TO REMOVE STACK FRAME
    jr  $ra
