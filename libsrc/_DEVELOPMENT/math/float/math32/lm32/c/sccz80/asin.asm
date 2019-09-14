
    SECTION code_fp_math32
    PUBLIC  asin

IF __CLASSIC
    EXTERN  cm32_sccz80_asin
    defc    asin = cm32_sccz80_asin

    ; SDCC bridge for Classic
    PUBLIC  _asin
    defc    _asin = asin
ELSE
    EXTERN  _m32_asinf
    defc    asin = _m32_asinf
ENDIF
