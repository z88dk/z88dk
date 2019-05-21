

SECTION code_fp_math32
PUBLIC cm32_sccz80_acos

EXTERN _m32_acosf

cm32_sccz80_acos:
        pop     bc
        pop     hl
        pop     de
        push    de
        push    hl
        push    bc
        jp      _m32_acosf
