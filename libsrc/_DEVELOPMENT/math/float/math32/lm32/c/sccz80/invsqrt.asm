
    SECTION code_fp_math32

    PUBLIC invsqrt
    EXTERN m32_fsinvsqrt_fastcall

    defc invsqrt = m32_fsinvsqrt_fastcall

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _invsqrt
defc _invsqrt = m32_fsinvsqrt_fastcall
ENDIF

