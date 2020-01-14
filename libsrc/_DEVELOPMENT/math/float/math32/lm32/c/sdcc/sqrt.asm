
    SECTION code_fp_math32
    PUBLIC _sqrt
    EXTERN cm32_sdcc_fssqrt

    defc _sqrt = cm32_sdcc_fssqrt
