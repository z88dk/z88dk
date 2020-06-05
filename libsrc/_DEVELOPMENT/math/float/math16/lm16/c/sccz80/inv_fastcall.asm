
    SECTION code_fp_math16
    PUBLIC m16_inv_fastcall
    EXTERN asm_f16_inv

    defc m16_inv_fastcall = asm_f16_inv


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _m16_inv_fastcall
defc _m16_inv_fastcall = asm_f16_inv
ENDIF

