
    SECTION code_fp_math16

    PUBLIC ___hadd
    PUBLIC _f16_add

    EXTERN cm16_sdcc_add

    defc ___hadd = cm16_sdcc_add
    defc _f16_add = cm16_sdcc_add
