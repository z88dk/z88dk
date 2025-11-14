

SECTION code_fp_math32

PUBLIC cm32_sccz80_fsinvsqrt

EXTERN cm32_sccz80_fsread1, m32_fsinvsqrt_fastcall

    ; inverse square root sccz80 float
    ;
    ; enter : stack = sccz80_float number, ret
    ;
    ; exit  :  DEHL = sccz80_float(1/number^0.5)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

cm32_sccz80_fsinvsqrt:
    call cm32_sccz80_fsread1
    jp m32_fsinvsqrt_fastcall
