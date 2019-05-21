

SECTION code_fp_math32
PUBLIC cm32_sccz80_exp

EXTERN _m32_expf

cm32_sccz80_exp:
        pop     bc
        pop     hl
        pop     de
        push    de
        push    hl
        push    bc
        jp      _m32_expf
