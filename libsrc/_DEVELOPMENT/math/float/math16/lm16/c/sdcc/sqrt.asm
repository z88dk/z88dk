
    SECTION code_fp_math16
    PUBLIC  _f16_sqrt
    EXTERN  cm16_sdcc_sqrt

    defc    _f16_sqrt = cm16_sdcc_sqrt
