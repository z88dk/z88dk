
    SECTION code_fp_math32
    PUBLIC _sqrt_fastcall
    EXTERN m32_fssqrt_fastcall

    defc _sqrt_fastcall = m32_fssqrt_fastcall
