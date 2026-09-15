
    SECTION code_fp_math32
    PUBLIC  fmax_callee
    EXTERN  cm32_sccz80_fmax_callee

    defc    fmax_callee = cm32_sccz80_fmax_callee

    ; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
    ; Exported for both Classic and Newlib.
    PUBLIC  _fmax_callee
    defc    _fmax_callee = fmax_callee

