
    SECTION code_fp_math32

    PUBLIC sqrt_fastcall
    EXTERN m32_fssqrt_fastcall

    defc sqrt_fastcall = m32_fssqrt_fastcall

    ; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
    ; Exported for both Classic and Newlib.
    PUBLIC _sqrt_fastcall
    defc _sqrt_fastcall = m32_fssqrt_fastcall

