
    SECTION code_fp_math32
    PUBLIC  atan2_callee
    EXTERN  cm32_sccz80_atan2_callee

    defc    atan2_callee = cm32_sccz80_atan2_callee

IF __CLASSIC
    ; SDCC bridge for Classic
    PUBLIC  _atan2_callee
    defc    _atan2_callee = atan2_callee
ENDIF
