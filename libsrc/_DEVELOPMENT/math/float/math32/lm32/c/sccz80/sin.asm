
    SECTION code_fp_math32
    PUBLIC  sin

IF __CLASSIC
    EXTERN  cm32_sccz80_sin
    defc    sin = cm32_sccz80_sin

    ; SDCC bridge for Classic
    PUBLIC  _sin
    defc    _sin = sin
ELSE
    EXTERN  _m32_sinf
    defc    sin = _m32_sinf
ENDIF
