
    SECTION code_fp_math32
    PUBLIC  fmin_callee
    EXTERN  cm32_sccz80_fmin_callee

    defc    fmin_callee = cm32_sccz80_fmin_callee

    ; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
    ; Exported for both Classic and Newlib.
    PUBLIC  _fmin_callee
    defc    _fmin_callee = fmin_callee

