
    SECTION code_fp_am9511
    PUBLIC  fmax_callee
    EXTERN  cam32_sccz80_fmax_callee

    defc    fmax_callee = cam32_sccz80_fmax_callee

IF __CLASSIC
    ; SDCC bridge for Classic
    PUBLIC  _fmax_callee
    EXTERN  cam32_sdcc_fmax_callee
    defc    _fmax_callee = cam32_sdcc_fmax_callee
ENDIF
