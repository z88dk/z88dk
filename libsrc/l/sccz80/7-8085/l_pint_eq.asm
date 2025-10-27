;   Z88 Small C+ Run time Library
;   Moved functions over to proper libdefs
;   To make startup code smaller and neater!
;
;   6/9/98  djm
;
;   feilipu 10/2021

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_pint_eq

.l_pint_eq
    ld (de),hl

    ld a,h
    or l
    ret
