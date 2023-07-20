
SECTION code_l_clang

IF __CPU_Z80__ | __CPU_EZ80__

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
ENDIF
