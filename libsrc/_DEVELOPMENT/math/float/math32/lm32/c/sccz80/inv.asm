
    SECTION code_fp_math32
    PUBLIC  inv

IF __CLASSIC
    EXTERN  cm32_sccz80_fsinv
    defc    inv = cm32_sccz80_fsinv

    ; SDCC bridge for Classic
    PUBLIC  _inv
    defc    _inv = inv
ELSE
    EXTERN  m32_fsinv_fastcall
    defc    inv = m32_fsinv_fastcall
ENDIF
