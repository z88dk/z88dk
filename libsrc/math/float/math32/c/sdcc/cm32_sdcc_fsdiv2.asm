
SECTION code_fp_math32

PUBLIC cm32_sdcc_fsdiv2

EXTERN cm32_sdcc_fsread1, m32_fsdiv2_fastcall

cm32_sdcc_fsdiv2:
    call cm32_sdcc_fsread1
    jp m32_fsdiv2_fastcall
