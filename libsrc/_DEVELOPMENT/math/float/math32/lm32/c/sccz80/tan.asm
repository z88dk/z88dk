
    SECTION code_fp_math32
    PUBLIC  tan

IF __CLASSIC
    EXTERN  cm32_sccz80_tan
    defc    tan = cm32_sccz80_tan

    ; SDCC bridge for Classic
    PUBLIC  _tan
    defc    _tan = tan
ELSE
    EXTERN  _m32_tanf
    defc    tan = _m32_tanf
ENDIF
