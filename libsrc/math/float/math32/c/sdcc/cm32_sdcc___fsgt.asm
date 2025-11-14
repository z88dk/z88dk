

SECTION code_fp_math32

PUBLIC  cm32_sdcc___fsgt

EXTERN m32_compare

; Entry: stack: float right, float left, ret
cm32_sdcc___fsgt:
    call    m32_compare
    jr      z,gt1
    ccf
    ret     c
gt1:
    dec     hl
    ret
