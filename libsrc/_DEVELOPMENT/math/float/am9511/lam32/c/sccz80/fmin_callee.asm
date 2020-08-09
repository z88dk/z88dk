
    SECTION code_fp_am9511
    PUBLIC  fmin_callee
    EXTERN  cam32_sccz80_fmin_callee

    defc    fmin_callee = cam32_sccz80_fmin_callee

IF __CLASSIC
    ; SDCC bridge for Classic
    PUBLIC  _fmin_callee
    EXTERN cam32_sdcc_fmin_callee
    defc    _fmin_callee = cam32_sdcc_fmin_callee
ENDIF
