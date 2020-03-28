
    SECTION code_fp_math32

    PUBLIC invsqrt
    EXTERN m32_fsinvsqrt_fastcall

    defc invsqrt = m32_fsinvsqrt_fastcall

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _invsqrt
EXTERN cm32_sdcc_fsinvsqrt
defc _invsqrt = cm32_sdcc_fsinvsqrt
ENDIF

