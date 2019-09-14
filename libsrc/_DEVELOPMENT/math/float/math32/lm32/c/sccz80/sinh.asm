
    SECTION code_fp_math32
    PUBLIC  sinh

IF __CLASSIC
    EXTERN  cm32_sccz80_sinh
    defc    sinh = cm32_sccz80_sinh

    ; SDCC bridge for Classic
    PUBLIC  _sinh
    defc    _sinh = sinh
ELSE
    EXTERN  _m32_sinhf
    defc    sinh = _m32_sinhf
ENDIF
