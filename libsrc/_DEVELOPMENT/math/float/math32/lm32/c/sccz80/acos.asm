
    SECTION code_fp_math32
    PUBLIC  acos

IF __CLASSIC
    EXTERN  cm32_sccz80_acos
    defc    acos = cm32_sccz80_acos

    ; SDCC bridge for Classic
    PUBLIC  _acos
    defc    _acos = acos
ELSE
    EXTERN  _m32_acosf
    defc    acos = _m32_acosf
ENDIF
