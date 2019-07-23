

SECTION code_fp_math32
PUBLIC cm32_sdcc_fpclassify

EXTERN _m32_fpclassify

cm32_sdcc_fpclassify:
        exx
        pop     bc
        pop     hl
        pop     de
        push    de
        push    hl
        push    bc
        exx
        jp      _m32_fpclassify
