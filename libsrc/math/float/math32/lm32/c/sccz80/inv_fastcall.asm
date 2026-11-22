
    SECTION code_fp_math32

    PUBLIC inv_fastcall
    EXTERN m32_fsinv_fastcall

    defc inv_fastcall = m32_fsinv_fastcall

    ; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
    ; Exported for both Classic and Newlib.
    PUBLIC _inv_fastcall
    defc _inv_fastcall = m32_fsinv_fastcall

