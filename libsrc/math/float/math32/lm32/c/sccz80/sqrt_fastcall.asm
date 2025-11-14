
    SECTION code_fp_math32

    PUBLIC sqrt_fastcall
    EXTERN m32_fssqrt_fastcall

    defc sqrt_fastcall = m32_fssqrt_fastcall

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sqrt_fastcall
defc _sqrt_fastcall = m32_fssqrt_fastcall
ENDIF

