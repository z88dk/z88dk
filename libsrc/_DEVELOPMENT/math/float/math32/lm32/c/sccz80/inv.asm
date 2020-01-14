
    SECTION code_fp_math32

    PUBLIC inv
    EXTERN m32_fsinv_fastcall

    defc inv = m32_fsinv_fastcall

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _inv
EXTERN cm32_sdcc_fsinv
defc _inv = cm32_sdcc_fsinv
ENDIF

