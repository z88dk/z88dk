
    SECTION code_fp_math32
    PUBLIC  fmod_callee
    EXTERN  cm32_sccz80_fmod_callee

    defc    fmod_callee = cm32_sccz80_fmod_callee

IF __CLASSIC
    ; SDCC bridge for Classic
    PUBLIC  _fmod_callee
    defc    _fmod_callee = fmod_callee
ENDIF
