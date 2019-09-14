
    SECTION code_fp_math32
    PUBLIC  cos

IF __CLASSIC
    EXTERN  cm32_sccz80_cos
    defc    cos = cm32_sccz80_cos

    ; SDCC bridge for Classic
    PUBLIC  _cos
    defc    _cos = cos
ELSE
    EXTERN  _m32_cosf
    defc    cos = _m32_cosf
ENDIF
