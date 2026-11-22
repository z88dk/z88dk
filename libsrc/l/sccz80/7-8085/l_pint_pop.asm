;   Z88 Small C+ Run time Library
;   Moved functions over to proper libdefs
;   To make startup code smaller and neater!
;
;   23/1/2001  djm
;
;   feilipu 10/2021

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_pint_pop, l_pint_pop_pint

.l_pint_pop
    pop bc                  ; return address
    pop de                  ; where to put it
    push bc

; store int from HL into (DE)
.l_pint_pop_pint
    ld (de),hl
    ret
