

SECTION code_fp_math32

PUBLIC cm32_sccz80_fsmin

EXTERN cm32_sccz80_fsread1, m32_fsmin_fastcall

    ; change underflow to a error floating zero as sccz80 float
    ;
    ; enter : stack = sccz80_float number, ret
    ;
    ; exit  :  DEHL = sccz80_float(0)
    ;
    ; uses  : af, bc, de, hl

cm32_sccz80_fsmin:
    call cm32_sccz80_fsread1
    jp m32_fsmin_fastcall
