
SECTION code_fp_math32

PUBLIC cm32_sccz80_floor
EXTERN m32_floor_fastcall


cm32_sccz80_floor:
        pop     bc
        pop     hl
        pop     de
        push    de
        push    hl
        push    bc
        jp      m32_floor_fastcall
