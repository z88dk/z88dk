
    SECTION code_fp_math32
    PUBLIC  atan

IF __CLASSIC
    EXTERN  cm32_sccz80_atan
    defc    atan = cm32_sccz80_atan

    ; SDCC bridge for Classic
    PUBLIC  _atan
    defc    _atan = atan
ELSE
    EXTERN  _m32_atanf
    defc    atan = _m32_atanf
ENDIF
