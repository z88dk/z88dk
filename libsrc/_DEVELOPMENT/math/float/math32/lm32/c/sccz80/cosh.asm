
    SECTION code_fp_math32
    PUBLIC  cosh

IF __CLASSIC
    EXTERN  cm32_sccz80_cosh
    defc    cosh = cm32_sccz80_cosh

    ; SDCC bridge for Classic
    PUBLIC  _cosh
    defc    _cosh = cosh
ELSE
    EXTERN  _m32_coshf
    defc    cosh = _m32_coshf
ENDIF
