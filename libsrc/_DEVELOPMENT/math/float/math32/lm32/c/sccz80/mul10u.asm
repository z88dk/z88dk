
    SECTION code_fp_math32
    PUBLIC  mul10u

IF __CLASSIC
    EXTERN  cm32_sccz80_fsmul10u
    defc    mul10u = cm32_sccz80_fsmul10u

    ; SDCC bridge for Classic
    PUBLIC  _mul10u
    defc    _mul10u = mul10u
ELSE
    EXTERN  _m32_mul10uf
    defc    mul10u = _m32_mul10uf
ENDIF
