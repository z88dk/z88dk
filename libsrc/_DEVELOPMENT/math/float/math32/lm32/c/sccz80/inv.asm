
    SECTION code_fp_math32

    PUBLIC inv
    EXTERN m32_fsinv_fastcall

    defc inv = m32_fsinv_fastcall

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _inv
defc _inv = m32_fsinv_fastcall
ENDIF

