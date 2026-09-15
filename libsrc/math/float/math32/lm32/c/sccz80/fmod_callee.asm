
    SECTION code_fp_math32
    PUBLIC  fmod_callee
    EXTERN  cm32_sccz80_fmod_callee

    defc    fmod_callee = cm32_sccz80_fmod_callee

    ; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
    ; Exported for both Classic and Newlib.
    PUBLIC  _fmod_callee
    defc    _fmod_callee = fmod_callee

