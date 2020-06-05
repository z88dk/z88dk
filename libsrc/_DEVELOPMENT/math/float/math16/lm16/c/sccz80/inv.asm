
    SECTION code_fp_math16
    PUBLIC m16_inv
    EXTERN cm16_sccz80_inv

    defc m16_inv = cm16_sccz80_inv


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _m16_inv
EXTERN cm16_sdcc_inv
defc _m16_inv = cm16_sdcc_inv
ENDIF

