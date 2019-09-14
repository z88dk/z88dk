
    SECTION code_fp_math32
    PUBLIC  round

IF __CLASSIC
    EXTERN  cm32_sccz80_round
    defc    round = cm32_sccz80_round

    ; SDCC bridge for Classic
    PUBLIC  _round
    defc    _round = round
ELSE
    EXTERN  _m32_roundf
    defc    round = _m32_roundf
ENDIF
