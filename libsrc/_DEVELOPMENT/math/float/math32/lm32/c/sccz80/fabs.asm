
    SECTION code_fp_math32
    PUBLIC  fabs

IF __CLASSIC
    EXTERN  cm32_sccz80_fabs
    defc    fabs = cm32_sccz80_fabs

    ; SDCC bridge for Classic
    PUBLIC  _fabs
    defc    _fabs = fabs
ELSE
    EXTERN  m32_fabs_fastcall
    defc    fabs = m32_fabs_fastcall
ENDIF
