
    SECTION code_fp_math32
    PUBLIC  div2

IF __CLASSIC
    EXTERN  cm32_sccz80_fsdiv2
    defc    div2 = cm32_sccz80_fsdiv2

    ; SDCC bridge for Classic
    PUBLIC  _div2
    defc    _div2 = div2
ELSE
    EXTERN  _m32_div2f
    defc    div2 = _m32_div2f
ENDIF
