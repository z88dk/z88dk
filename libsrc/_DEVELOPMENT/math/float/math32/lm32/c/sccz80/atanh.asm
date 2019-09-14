
    SECTION code_fp_math32
    PUBLIC  atanh

IF __CLASSIC
    EXTERN  cm32_sccz80_atanh
    defc    atanh = cm32_sccz80_atanh

    ; SDCC bridge for Classic
    PUBLIC  _atanh
    defc    _atanh = atanh
ELSE
    EXTERN  _m32_atanhf
    defc    atanh = _m32_atanhf
ENDIF
