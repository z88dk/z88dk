
    SECTION code_fp_am9511
    PUBLIC  modf_callee
    EXTERN  cam32_sccz80_modf_callee

    defc    modf_callee = cam32_sccz80_modf_callee

IF __CLASSIC
    ; SDCC bridge for Classic
    PUBLIC  _modf_callee
    EXTERN cam32_sdcc_modf_callee
    defc    _modf_callee = cam32_sdcc_modf_callee
ENDIF
