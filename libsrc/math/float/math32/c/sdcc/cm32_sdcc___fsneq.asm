

SECTION code_fp_math32

PUBLIC  cm32_sdcc___fsneq

EXTERN m32_compare

; Entry: stack: float right, float left, ret
cm32_sdcc___fsneq:
    call    m32_compare
    scf
    ret     nz
    ccf
    dec     hl
    ret
