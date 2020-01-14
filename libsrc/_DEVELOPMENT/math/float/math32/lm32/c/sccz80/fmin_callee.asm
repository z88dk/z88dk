
    SECTION code_fp_math32
    PUBLIC  fmin_callee
    EXTERN  cm32_sccz80_fmin_callee

    defc    fmin_callee = cm32_sccz80_fmin_callee

IF __CLASSIC
    ; SDCC bridge for Classic
    PUBLIC  _fmin_callee
    EXTERN cm32_sdcc_fmin_callee
    defc    _fmin_callee = cm32_sdcc_fmin_callee
ENDIF
