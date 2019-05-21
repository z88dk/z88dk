

SECTION code_fp_math32
PUBLIC cm32_sdcc_atanh

EXTERN _m32_atanhf

cm32_sdcc_atanh:
        pop     bc
        pop     hl
        pop     de
        push    de
        push    hl
        push    bc
        jp      _m32_atanhf
