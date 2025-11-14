SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_compare_true
PUBLIC l_compare_false

    ;K flag: If you're comparing two signed values,
    ;the first is smaller if the exclusive-or of the sign and overflow is 1.

    ; return hl=1 and set carry, hl=0 and clear carry otherwise

l_compare_true:
    scf
    ld hl,1
    ret

l_compare_false:
    xor a
    ld l,a
    ld h,a
    ret
