

    SECTION code_math
    EXTERN  asm_fix16_sqr
    EXTERN  asm_fix16_mult

; Square a number
; Entry: h.l
; Exit:  h.l
asm_fix16_sqr:
    ld      d,h
    ld      e,l
    jp      asm_fix16_mult