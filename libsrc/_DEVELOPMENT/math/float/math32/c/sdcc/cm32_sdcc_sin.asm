

SECTION code_fp_math32
PUBLIC cm32_sdcc_sin

EXTERN _m32_sinf

cm32_sdcc_sin:
        pop     bc
        pop     hl
        pop     de
        push    de
        push    hl
        push    bc
        jp      _m32_sinf
