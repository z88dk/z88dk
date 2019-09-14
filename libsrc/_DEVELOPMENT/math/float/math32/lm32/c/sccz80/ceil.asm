
    SECTION code_fp_math32
    PUBLIC  ceil

IF __CLASSIC
    EXTERN  cm32_sccz80_ceil
    defc    ceil = cm32_sccz80_ceil

    ; SDCC bridge for Classic
    PUBLIC  _ceil
    defc    _ceil = ceil
ELSE
    EXTERN  m32_ceil_fastcall
    defc    ceil = m32_ceil_fastcall
ENDIF
