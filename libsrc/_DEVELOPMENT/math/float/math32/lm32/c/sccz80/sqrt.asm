
    SECTION code_fp_math32

    PUBLIC sqrt
    EXTERN m32_fssqrt_fastcall

    defc sqrt = m32_fssqrt_fastcall

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sqrt
EXTERN cm32_sdcc_fssqrt
defc _sqrt = cm32_sdcc_fssqrt
ENDIF

