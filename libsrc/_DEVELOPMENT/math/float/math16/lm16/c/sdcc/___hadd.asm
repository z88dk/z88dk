
    SECTION code_fp_math16

    PUBLIC ___hadd
    PUBLIC _m16_add

    EXTERN cm16_sdcc_add

    defc ___hadd = cm16_sdcc_add
    defc _m16_add = cm16_sdcc_add
