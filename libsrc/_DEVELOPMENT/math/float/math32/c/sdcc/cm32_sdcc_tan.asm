

SECTION code_fp_math32
PUBLIC cm32_sdcc_tan

EXTERN _m32_tanf

cm32_sdcc_tan:
        pop     bc
        pop     hl
        pop     de
        push    de
        push    hl
        push    bc
        jp      _m32_tanf
