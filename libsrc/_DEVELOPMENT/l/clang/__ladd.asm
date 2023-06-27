
SECTION code_l_clang

PUBLIC __ladd
EXTERN l_neg_hl

; dehl + iybc
__ladd:
    push af	;TODO Necessary?
    add  hl,bc
    ld a,iyl
    adc e
    ld e,a
    ld a,iyh
    adc d
    ld d,a
    pop  af
    ret
