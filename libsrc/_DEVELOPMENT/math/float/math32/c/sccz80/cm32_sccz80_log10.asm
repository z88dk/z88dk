

SECTION code_fp_math32
PUBLIC cm32_sccz80_log10

EXTERN _m32_log10f

cm32_sccz80_log10:
        pop     bc
        pop     hl
        pop     de
        push    de
        push    hl
        push    bc
        jp      _m32_log10f
