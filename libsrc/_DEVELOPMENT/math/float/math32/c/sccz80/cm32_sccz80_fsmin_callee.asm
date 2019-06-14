

SECTION code_fp_math32

PUBLIC cm32_sccz80_fsmin_callee

EXTERN cm32_sccz80_fsread1_callee, m32_fsmin_fastcall

    ; change underflow to a error floating zero as sccz80 float
    ;
    ; enter : stack = sccz80_float number, ret
    ;
    ; exit  :  DEHL = sccz80_float(0)
    ;
    ; uses  : af, bc, de, hl

cm32_sccz80_fsmin_callee:
    call cm32_sccz80_fsread1_callee
    jp m32_fsmin_fastcall
