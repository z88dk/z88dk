
    SECTION code_fp_math32

    PUBLIC sqr
    EXTERN m32_fssqr_fastcall

    defc sqr = m32_fssqr_fastcall

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sqr
defc _sqr = m32_fssqr_fastcall
ENDIF

