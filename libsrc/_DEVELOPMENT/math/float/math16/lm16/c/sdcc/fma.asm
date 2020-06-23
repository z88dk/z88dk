
    SECTION code_fp_math16
    PUBLIC  _fmaf16
    EXTERN  cm16_sdcc_fma

    defc    _fmaf16 = cm16_sdcc_fma
