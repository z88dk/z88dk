
SECTION code_clib
SECTION code_l

PUBLIC l_neg_bc

; negate bc
;
; enter : bc = int
;
; exit  : bc = -bc
;
; uses  : af, bc, carry unaffected

.l_neg_bc
    ld a,c
    cpl
    ld c,a

    ld a,b
    cpl
    ld b,a

    inc bc
    ret
