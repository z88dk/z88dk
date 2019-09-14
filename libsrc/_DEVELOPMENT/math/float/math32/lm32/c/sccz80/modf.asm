
    SECTION code_fp_math32
    PUBLIC  modf
    EXTERN  cm32_sccz80_modf

    defc    modf = cm32_sccz80_modf

IF __CLASSIC
    ; SDCC bridge for Classic
    PUBLIC  _modf
    defc    _modf = modf
ENDIF
