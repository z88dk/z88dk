
    SECTION code_fp_math16
    PUBLIC inv_fastcall
    EXTERN asm_f16_inv

    defc inv_fastcall = asm_f16_inv


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _inv_fastcall
defc _inv_fastcall = asm_f16_inv
ENDIF

