
SECTION code_l_clang

IF __CPU_Z80__ | __CPU_EZ80__
PUBLIC __ladd
EXTERN l_neg_hl

; dehl = dehl + iybc
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
ENDIF
