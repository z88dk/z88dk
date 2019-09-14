
    SECTION code_fp_math32
    PUBLIC  invsqrt

IF __CLASSIC
    EXTERN  cm32_sccz80_fsinvsqrt
    defc    invsqrt = cm32_sccz80_fsinvsqrt

    ; SDCC bridge for Classic
    PUBLIC  _invsqrt
    defc    _invsqrt = invsqrt
ELSE
    EXTERN  m32_fsinvsqrt_fastcall
    defc    invsqrt = m32_fsinvsqrt_fastcall
ENDIF
