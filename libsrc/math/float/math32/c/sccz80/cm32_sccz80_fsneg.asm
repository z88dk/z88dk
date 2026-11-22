

SECTION code_fp_math32
PUBLIC cm32_sccz80_fsneg

EXTERN cm32_sccz80_fsread1, m32_fsneg

    ; negate sccz80 floats
    ;
    ; enter : stack = sccz80_float number, ret
    ;
    ; exit  :  DEHL = sccz80_float(-number)
    ;
    ; uses  : af, bc, de, hl

cm32_sccz80_fsneg:
    call cm32_sccz80_fsread1
    jp m32_fsneg
