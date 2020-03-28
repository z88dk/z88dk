
    SECTION code_fp_math32

    PUBLIC sqr_fastcall
    EXTERN m32_fssqr_fastcall

    defc sqr_fastcall = m32_fssqr_fastcall

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sqr_fastcall
defc _sqr_fastcall = m32_fssqr_fastcall
ENDIF

