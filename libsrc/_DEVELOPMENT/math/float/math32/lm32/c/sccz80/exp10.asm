
    SECTION code_fp_math32
    PUBLIC  exp10

IF __CLASSIC
    EXTERN  cm32_sccz80_exp10
    defc    exp10 = cm32_sccz80_exp10

    ; SDCC bridge for Classic
    PUBLIC  _exp10
    defc    _exp10 = exp10
ELSE
    EXTERN  _m32_exp10f
    defc    exp10 = _m32_exp10f
ENDIF
