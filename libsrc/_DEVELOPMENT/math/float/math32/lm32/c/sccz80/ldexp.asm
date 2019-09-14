
    SECTION code_fp_math32
    PUBLIC  ldexp
    EXTERN  cm32_sccz80_ldexp

    defc    ldexp = cm32_sccz80_ldexp

IF __CLASSIC
    ; SDCC bridge for Classic
    PUBLIC  _ldexp
    defc    _ldexp = ldexp
ENDIF
