
    SECTION code_fp_math32
    PUBLIC  fmod
    EXTERN  cm32_sccz80_fmod

    defc    fmod = cm32_sccz80_fmod

IF __CLASSIC
    ; SDCC bridge for Classic
    PUBLIC _fmod
    defc _fmod = fmod
ENDIF
