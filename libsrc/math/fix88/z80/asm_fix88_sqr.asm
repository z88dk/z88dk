

    SECTION code_math
    EXTERN  asm_fix88_sqr
    EXTERN  asm_fix88_mult

; Square a number
; Entry: h.l
; Exit:  h.l
asm_fix88_sqr:
    ld      d,h
    ld      e,l
    jp      asm_fix88_mult