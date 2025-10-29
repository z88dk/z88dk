
SECTION code_l_clang

PUBLIC __lnot
EXTERN l_neg_hl

; ~dehl
__lnot:
    push af	;TODO Necessary?
    ld a,l
    cpl
    ld l,a
    ld a,h
    cpl
    ld h,a
    ld a,e
    cpl
    ld e,a
    ld a,d
    cpl
    ld d,a

    pop af
    ret
