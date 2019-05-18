

SECTION code_fp_math32
PUBLIC cm32_sdcc_log

EXTERN _m32_logf

cm32_sdcc_log:
        pop     bc
        pop     hl
        pop     de
        push    de
        push    hl
        push    bc
        jp      _m32_logf
