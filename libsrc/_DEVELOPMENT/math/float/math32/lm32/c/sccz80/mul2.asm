
    SECTION code_fp_math32
    PUBLIC  mul2

IF __CLASSIC
    EXTERN  cm32_sccz80_fsmul2
    defc    mul2 = cm32_sccz80_fsmul2

    ; SDCC bridge for Classic
    PUBLIC  _mul2
    defc    _mul2 = mul2
ELSE
    EXTERN  _m32_mul2f
    defc    mul2 = _m32_mul2f
ENDIF
