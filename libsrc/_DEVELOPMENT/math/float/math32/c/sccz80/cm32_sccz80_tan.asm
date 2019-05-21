

SECTION code_fp_math32
PUBLIC cm32_sccz80_tan

EXTERN _m32_tanf

cm32_sccz80_tan:
        pop     bc
        pop     hl
        pop     de
        push    de
        push    hl
        push    bc
        jp      _m32_tanf
