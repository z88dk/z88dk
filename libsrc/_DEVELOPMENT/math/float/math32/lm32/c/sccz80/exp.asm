
    SECTION code_fp_math32
    PUBLIC  exp

IF __CLASSIC
    EXTERN  cm32_sccz80_exp
    defc    exp = cm32_sccz80_exp

    ; SDCC bridge for Classic
    PUBLIC  _exp
    defc    _exp = exp
ELSE
    EXTERN  _m32_expf
    defc    exp = _m32_expf
ENDIF
