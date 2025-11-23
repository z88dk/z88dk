
    SECTION code_fp_math16

    PUBLIC ___hadd
    PUBLIC _addf16

    EXTERN cm16_sdcc_add

    defc ___hadd = cm16_sdcc_add
    defc _addf16 = cm16_sdcc_add
