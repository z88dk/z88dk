

SECTION code_fp_math32
PUBLIC cm32_sdcc_cosh

EXTERN _m32_coshf

cm32_sdcc_cosh:
        pop     bc
        pop     hl
        pop     de
        push    de
        push    hl
        push    bc
        jp      _m32_coshf
