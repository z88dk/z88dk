
    SECTION code_fp_math32
    PUBLIC  sqr

IF __CLASSIC
    EXTERN  cm32_sccz80_fssqr
    defc    sqr = cm32_sccz80_fssqr

    ; SDCC bridge for Classic
    PUBLIC  _sqr
    defc    _sqr = sqr
ELSE
    EXTERN  m32_fssqr_fastcall
    defc    sqr = m32_fssqr_fastcall
ENDIF
