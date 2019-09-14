
    SECTION code_fp_math32
    PUBLIC  asinh
    
IF __CLASSIC    
    EXTERN  cm32_sccz80_asinh
    defc    asinh = cm32_sccz80_asinh

    ; SDCC bridge for Classic
    PUBLIC  _asinh
    defc    _asinh = asinh
ELSE
    EXTERN  _m32_asinhf
    defc    asinh = _m32_asinhf
ENDIF
