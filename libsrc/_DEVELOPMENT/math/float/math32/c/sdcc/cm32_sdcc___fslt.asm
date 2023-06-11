

SECTION code_fp_math32

PUBLIC  cm32_sdcc___fslt

EXTERN m32_compare

; Entry: stack: float right, float left, ret
cm32_sdcc___fslt:
    call    m32_compare
    ret     c
    dec     hl
    ret
