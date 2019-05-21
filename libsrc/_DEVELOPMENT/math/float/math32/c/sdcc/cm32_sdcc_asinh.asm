

SECTION code_fp_math32
PUBLIC cm32_sdcc_asinh

EXTERN _m32_asinhf

cm32_sdcc_asinh:
        pop     bc
        pop     hl
        pop     de
        push    de
        push    hl
        push    bc
        jp      _m32_asinhf
