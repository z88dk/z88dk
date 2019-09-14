
    SECTION code_fp_math32
    PUBLIC  poly_callee
    EXTERN  cm32_sccz80_fspoly_callee

    defc    poly_callee = cm32_sccz80_fspoly_callee

IF __CLASSIC
    ; SDCC bridge for Classic
    PUBLIC  _poly_callee
    defc    _poly_callee = poly_callee
ENDIF
