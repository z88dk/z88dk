
    SECTION code_fp_math32
    PUBLIC  hypot
    EXTERN  cm32_sccz80_fshypot

    defc    hypot = cm32_sccz80_fshypot

IF __CLASSIC
    ; SDCC bridge for Classic
    PUBLIC  _hypot
    defc    _hypot = hypot
ENDIF
