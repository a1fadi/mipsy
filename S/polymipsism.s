    .data

err_full_object_str:
    .asciiz "error: tried to add fn to full object\n"

err_find_fn_str:
    .asciiz "error: could not find function\n"

    .text

make_object:
    jr  $ra




obj_define:
    jr  $ra




obj_call:
    jr  $ra
