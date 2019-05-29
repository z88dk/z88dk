
SECTION code_fp_math32

PUBLIC cm32_sccz80_ceil
EXTERN m32_ceil_fastcall


cm32_sccz80_ceil:
        pop     bc
        pop     hl
        pop     de
        push    de
        push    hl
        push    bc
        jp      m32_ceil_fastcall
