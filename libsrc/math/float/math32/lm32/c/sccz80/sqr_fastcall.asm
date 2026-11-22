
    SECTION code_fp_math32

    PUBLIC sqr_fastcall
    EXTERN m32_fssqr_fastcall

    defc sqr_fastcall = m32_fssqr_fastcall

    ; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
    ; Exported for both Classic and Newlib.
    PUBLIC _sqr_fastcall
    defc _sqr_fastcall = m32_fssqr_fastcall

