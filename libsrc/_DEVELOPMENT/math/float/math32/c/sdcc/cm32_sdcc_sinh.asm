

SECTION code_fp_math32
PUBLIC cm32_sdcc_sinh

EXTERN _m32_sinhf

cm32_sdcc_sinh:
        pop     bc
        pop     hl
        pop     de
        push    de
        push    hl
        push    bc
        jp      _m32_sinhf
