
SECTION code_fp_math32

PUBLIC cm32_sdcc_fabs

EXTERN m32_fabs_fastcall

cm32_sdcc_fabs:
    call cm32_sdcc_fsread1
    jp m32_fabs_fastcall
