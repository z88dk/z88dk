

SECTION code_fp_math32

PUBLIC cm32_sccz80_fsmax_callee

EXTERN cm32_sccz80_fsread1_callee, m32_fsmax

    ; convert sccz80 float to infinity with correct sign
    ;
    ; enter : stack = sccz80_float number, ret
    ;
    ; exit  :  DEHL = sccz80_float(infinity)
    ;
    ; uses  : af, bc, de, hl

cm32_sccz80_fsmax_callee:
    call cm32_sccz80_fsread1_callee
    jp m32_fsmax
