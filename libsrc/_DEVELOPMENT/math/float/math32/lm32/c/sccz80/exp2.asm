
    SECTION code_fp_math32
    PUBLIC  exp2

IF __CLASSIC
    EXTERN  cm32_sccz80_exp2
    defc    exp2 = cm32_sccz80_exp2

    ; SDCC bridge for Classic
    PUBLIC  _exp2
    defc    _exp2 = exp2
ELSE
    EXTERN  _m32_exp2f
    defc    exp2 = _m32_exp2f
ENDIF
