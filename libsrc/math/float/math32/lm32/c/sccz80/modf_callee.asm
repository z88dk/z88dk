
    SECTION code_fp_math32
    PUBLIC  modf_callee
    EXTERN  cm32_sccz80_modf_callee

    defc    modf_callee = cm32_sccz80_modf_callee

    ; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
    ; Exported for both Classic and Newlib.
    PUBLIC  _modf_callee
    defc    _modf_callee = modf_callee

