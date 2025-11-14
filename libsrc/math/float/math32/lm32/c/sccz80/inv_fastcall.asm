
    SECTION code_fp_math32

    PUBLIC inv_fastcall
    EXTERN m32_fsinv_fastcall

    defc inv_fastcall = m32_fsinv_fastcall

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _inv_fastcall
defc _inv_fastcall = m32_fsinv_fastcall
ENDIF

