
SECTION code_crt_clang

PUBLIC __lsub

EXTERN l_neg_dehl

; dehl = iybc - dehl
__lsub:
    push af	;TODO Necessary?
    ; Negate before adding (brain fuzz makes this easier)
    call l_neg_dehl
    add  hl,bc
    ld a,iyl
    adc e
    ld e,a
    ld a,iyh
    adc d
    ld d,a
    pop  af
    ret
