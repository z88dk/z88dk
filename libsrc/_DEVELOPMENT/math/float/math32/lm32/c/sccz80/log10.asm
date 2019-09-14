
    SECTION code_fp_math32
    PUBLIC  log10

IF __CLASSIC
    EXTERN  cm32_sccz80_log10
    defc    log10 = cm32_sccz80_log10

    ; SDCC bridge for Classic
    PUBLIC  _log10
    defc    _log10 = log10
ELSE
    EXTERN  _m32_log10f
    defc    log10 = _m32_log10f
ENDIF
