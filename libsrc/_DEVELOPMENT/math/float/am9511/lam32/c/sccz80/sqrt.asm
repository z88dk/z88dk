
    SECTION code_fp_am9511

    PUBLIC sqrt
    EXTERN cam32_sccz80_sqrt

    defc sqrt = cam32_sccz80_sqrt

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sqrt
EXTERN cam32_sdcc_sqrt
defc _sqrt = cam32_sdcc_sqrt
ENDIF

