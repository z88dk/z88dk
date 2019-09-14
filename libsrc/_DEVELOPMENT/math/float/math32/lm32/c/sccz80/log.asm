
    SECTION code_fp_math32
    PUBLIC  log

IF __CLASSIC
    EXTERN  cm32_sccz80_log
    defc    log = cm32_sccz80_log

    ; SDCC bridge for Classic
    PUBLIC  _log
    defc    _log = log
ELSE
    EXTERN  _m32_logf
    defc    log = _m32_logf
ENDIF
