
    SECTION code_fp_math32
    PUBLIC  fpclassify
    EXTERN  cm32_sccz80_fpclassify

    defc    fpclassify = cm32_sccz80_fpclassify

IF __CLASSIC
    ; SDCC bridge for Classic
    PUBLIC  _fpclassify
    defc    _fpclassify = fpclassify
ENDIF
