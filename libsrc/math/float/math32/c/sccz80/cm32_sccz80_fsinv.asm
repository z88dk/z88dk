

SECTION code_fp_math32
PUBLIC cm32_sccz80_fsinv

EXTERN cm32_sccz80_fsread1, m32_fsinv_fastcall

    ; invert sccz80 float
    ;
    ; enter : stack = sccz80_float number, ret
    ;
    ; exit  :  DEHL = sccz80_float(1/number)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

cm32_sccz80_fsinv:
    call cm32_sccz80_fsread1
    jp m32_fsinv_fastcall
