

SECTION code_fp_math32
PUBLIC cm32_sdcc_cos

EXTERN _m32_cosf

cm32_sdcc_cos:
        pop     bc
        pop     hl
        pop     de
        push    de
        push    hl
        push    bc
        jp      _m32_cosf
