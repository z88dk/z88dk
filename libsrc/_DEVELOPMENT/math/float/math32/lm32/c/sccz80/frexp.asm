
    SECTION code_fp_math32
    PUBLIC  frexp
    EXTERN  cm32_sccz80_frexp

    defc    frexp = cm32_sccz80_frexp

IF __CLASSIC
    ; SDCC bridge for Classic
    PUBLIC  _frexp
    defc    _frexp = frexp
ENDIF
