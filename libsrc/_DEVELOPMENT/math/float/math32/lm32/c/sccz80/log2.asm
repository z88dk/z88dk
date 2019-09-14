
    SECTION code_fp_math32
    PUBLIC  log2

IF __CLASSIC
    EXTERN  cm32_sccz80_log2
    defc    log2 = cm32_sccz80_log2

    ; SDCC bridge for Classic
    PUBLIC  _log2
    defc    _log2 = log2
ELSE
    EXTERN  _m32_log2f
    defc    log2 = _m32_log2f
ENDIF
