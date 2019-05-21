

SECTION code_fp_math32
PUBLIC cm32_sccz80_acosh

EXTERN _m32_acoshf

cm32_sccz80_acosh:
        pop     bc
        pop     hl
        pop     de
        push    de
        push    hl
        push    bc
        jp      _m32_acoshf
