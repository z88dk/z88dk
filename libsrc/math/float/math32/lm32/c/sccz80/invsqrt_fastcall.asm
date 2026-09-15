
    SECTION code_fp_math32

    PUBLIC invsqrt_fastcall
    EXTERN m32_fsinvsqrt_fastcall

    defc invsqrt_fastcall = m32_fsinvsqrt_fastcall

    ; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
    ; Exported for both Classic and Newlib.
    PUBLIC _invsqrt_fastcall
    defc _invsqrt_fastcall = m32_fsinvsqrt_fastcall

