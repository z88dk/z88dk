
    SECTION code_fp_math32
    PUBLIC  tanh

IF __CLASSIC
    EXTERN  cm32_sccz80_tanh
    defc    tanh = cm32_sccz80_tanh

    ; SDCC bridge for Classic
    PUBLIC  _tanh
    defc    _tanh = tanh
ELSE
    EXTERN  _m32_tanhf
    defc    tanh = _m32_tanhf
ENDIF
