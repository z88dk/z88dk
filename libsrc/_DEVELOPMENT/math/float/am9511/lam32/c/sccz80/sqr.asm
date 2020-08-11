
    SECTION code_fp_am9511

    PUBLIC sqr
    EXTERN asm_am9511_sqr_fastcall

    defc sqr = asm_am9511_sqr_fastcall

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sqr
EXTERN cam32_sdcc_sqr
defc _sqr = cam32_sdcc_sqr
ENDIF

