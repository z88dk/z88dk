    SECTION code_clib
    SECTION code_fp_math16
    PUBLIC  _sqrf16
    EXTERN  cm16_sdcc_sqr

    defc    _sqrf16 = cm16_sdcc_sqr
