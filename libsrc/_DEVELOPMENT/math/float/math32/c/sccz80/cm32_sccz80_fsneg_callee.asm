

SECTION code_fp_math32
PUBLIC cm32_sccz80_fsneg_callee

EXTERN cm32_sccz80_fsread1_callee, m32_fsneg_fastcall

    ; negate sccz80 floats
    ;
    ; enter : stack = sccz80_float number, ret 
    ;
    ; exit  :  DEHL = sccz80_float(-number)
    ;
    ; uses  : af, bc, de, hl
    
cm32_sccz80_fsneg_callee:
    call cm32_sccz80_fsread1_callee
    jp m32_fsneg_fastcall

