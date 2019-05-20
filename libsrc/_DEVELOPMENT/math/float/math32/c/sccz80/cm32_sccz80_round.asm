

SECTION code_fp_math32
PUBLIC cm32_sccz80_round

EXTERN _m32_roundf

cm32_sccz80_round:
        pop     bc
        pop     hl
        pop     de
        push    de
        push    hl
        push    bc
        jp      _m32_roundf
