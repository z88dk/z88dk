
SECTION code_fp_math32

PUBLIC cm32_sdcc_ceil

EXTERN cm32_sdcc_fsread1, m32_ceil_fastcall

cm32_sdcc_ceil:
    call cm32_sdcc_fsread1
    jp m32_ceil_fastcall
