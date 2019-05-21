

SECTION code_fp_math32
PUBLIC cm32_sdcc_atan

EXTERN _m32_atanf

cm32_sdcc_atan:
        pop     bc
        pop     hl
        pop     de
        push    de
        push    hl
        push    bc
        jp      _m32_atanf
