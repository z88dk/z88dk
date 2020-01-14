
    SECTION code_fp_math32
    PUBLIC  modf_callee
    EXTERN  cm32_sccz80_modf_callee

    defc    modf_callee = cm32_sccz80_modf_callee

IF __CLASSIC
    ; SDCC bridge for Classic
    PUBLIC  _modf_callee
    EXTERN cm32_sdcc_modf_callee
    defc    _modf_callee = cm32_sdcc_modf_callee
ENDIF
