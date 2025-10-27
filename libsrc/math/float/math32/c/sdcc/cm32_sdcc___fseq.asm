

SECTION code_fp_math32

PUBLIC  cm32_sdcc___fseq

EXTERN m32_compare

; Entry: stack: float right, float left, ret
cm32_sdcc___fseq:
    call    m32_compare
    scf
    ret     z
    ccf
    dec     hl
    ret
