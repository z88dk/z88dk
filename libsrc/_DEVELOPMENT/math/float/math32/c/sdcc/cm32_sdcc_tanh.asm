

SECTION code_fp_math32
PUBLIC cm32_sdcc_tanh

EXTERN _m32_tanhf

cm32_sdcc_tanh:
        pop     bc
        pop     hl
        pop     de
        push    de
        push    hl
        push    bc
        jp      _m32_tanhf
