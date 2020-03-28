
    SECTION code_fp_math32
    PUBLIC  fmax_callee
    EXTERN  cm32_sccz80_fmax_callee

    defc    fmax_callee = cm32_sccz80_fmax_callee

IF __CLASSIC
    ; SDCC bridge for Classic
    PUBLIC  _fmax_callee
    EXTERN  cm32_sdcc_fmax_callee
    defc    _fmax_callee = cm32_sdcc_fmax_callee
ENDIF
