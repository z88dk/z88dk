
    SECTION code_fp_math32
    PUBLIC  ldexp_callee
    EXTERN  cm32_sccz80_ldexp_callee

    defc    ldexp_callee = cm32_sccz80_ldexp_callee

IF __CLASSIC
    ; SDCC bridge for Classic
    PUBLIC  _ldexp_callee
    defc    _ldexp_callee = ldexp_callee
ENDIF
