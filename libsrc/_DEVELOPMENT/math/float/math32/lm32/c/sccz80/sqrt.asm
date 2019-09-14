
    SECTION code_fp_math32
    PUBLIC  sqrt

IF __CLASSIC
    EXTERN  cm32_sccz80_fssqrt
    defc    sqrt = cm32_sccz80_fssqrt

    ; SDCC bridge for Classic
    PUBLIC  _sqrt
    defc    _sqrt = sqrt
ELSE
    EXTERN  m32_fssqrt_fastcall
    defc    sqrt = m32_fssqrt_fastcall
ENDIF
