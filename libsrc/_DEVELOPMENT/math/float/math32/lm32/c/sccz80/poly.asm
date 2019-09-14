
    SECTION code_fp_math32
    PUBLIC  poly
    EXTERN  cm32_sccz80_fspoly

    defc    poly = cm32_sccz80_fspoly

IF __CLASSIC
    ; SDCC bridge for Classic
    PUBLIC  _poly
    defc    _poly = poly
ENDIF
