;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm
;       13/5/99 djm Added carry conditions...


SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_eq
EXTERN  l_cmp

;
;
; DE == HL
; carry set if true

.l_eq
    ld a,l
    sub e
    ld l,a
    ld  a,h
    sbc a,d
    ld h,a
    or l
    inc hl
    scf
    ret z

    xor a
    ld l,a
    ld h,a
    ret
