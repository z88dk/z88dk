
    SECTION code_fp_math32
    PUBLIC  acosh

IF __CLASSIC
    EXTERN  cm32_sccz80_acosh
    defc    acosh = cm32_sccz80_acosh

    ; SDCC bridge for Classic
    PUBLIC  _acosh
    defc    _acosh = acosh
ELSE
    EXTERN  _m32_acoshf
    defc    acosh = _m32_acoshf
ENDIF
