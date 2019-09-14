
    SECTION code_fp_math32
    PUBLIC  atan2
    EXTERN  cm32_sccz80_atan2

    defc    atan2 = cm32_sccz80_atan2

IF __CLASSIC
    ; SDCC bridge for Classic
    PUBLIC  _atan2
    defc    _atan2 = atan2
ENDIF

