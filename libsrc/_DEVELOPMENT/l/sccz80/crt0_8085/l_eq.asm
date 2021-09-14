;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm
;       13/5/99 djm Added carry conditions
;       August 2021 feilipu aligned boolean conditions

SECTION code_crt0_sccz80

PUBLIC  l_eq

; DE == HL
; carry set if true

.l_eq
    ld a,l
    sub e
    ld l,a
    ld a,h
    sbc a,d
    or l

    ld hl,1
    scf
    ret Z

    xor a
    dec l
    ret
