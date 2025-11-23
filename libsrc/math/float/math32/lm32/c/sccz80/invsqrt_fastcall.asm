
    SECTION code_fp_math32

    PUBLIC invsqrt_fastcall
    EXTERN m32_fsinvsqrt_fastcall

    defc invsqrt_fastcall = m32_fsinvsqrt_fastcall

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _invsqrt_fastcall
defc _invsqrt_fastcall = m32_fsinvsqrt_fastcall
ENDIF

