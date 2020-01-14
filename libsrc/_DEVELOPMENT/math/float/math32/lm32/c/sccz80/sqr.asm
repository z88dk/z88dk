
    SECTION code_fp_math32

    PUBLIC sqr
    EXTERN m32_fssqr_fastcall

    defc sqr = m32_fssqr_fastcall

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sqr
EXTERN cm32_sdcc_fssqr
defc _sqr = cm32_sdcc_fssqr
ENDIF

