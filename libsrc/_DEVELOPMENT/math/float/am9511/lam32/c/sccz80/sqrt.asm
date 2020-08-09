
    SECTION code_fp_am9511

    PUBLIC sqrt
    EXTERN asm_am9511_sqrt_fastcall

    defc sqrt = asm_am9511_sqrt_fastcall

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sqrt
EXTERN cam32_sdcc_sqrt
defc _sqrt = cam32_sdcc_sqrt
ENDIF

