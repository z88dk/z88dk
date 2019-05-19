

SECTION code_fp_math32
PUBLIC cm32_sccz80_fpclassify

EXTERN _m32_fpclassify

cm32_sccz80_fpclassify:
        pop     bc
        pop     hl
        pop     de
        push    de
        push    hl
        push    bc
        jp      _m32_fpclassify
