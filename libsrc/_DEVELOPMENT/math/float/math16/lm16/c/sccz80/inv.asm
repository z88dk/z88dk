
    SECTION code_fp_math16
    PUBLIC inv
    EXTERN cm16_sccz80_inv

    defc inv = cm16_sccz80_inv


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _inv
EXTERN cm16_sdcc_inv
defc _inv = cm16_sdcc_inv
ENDIF

