
    SECTION code_fp_am9511
    PUBLIC  fmod_callee
    EXTERN  cam32_sccz80_fmod_callee

    defc    fmod_callee = cam32_sccz80_fmod_callee

IF __CLASSIC
    ; SDCC bridge for Classic
    PUBLIC  _fmod_callee
    EXTERN  cam32_sdcc_fmod_callee
    defc    _fmod_callee = cam32_sdcc_fmod_callee
ENDIF
