
SECTION code_fp_math32

PUBLIC cm32_sdcc_fsmul2

EXTERN cm32_sdcc_fsread1, m32_fsmul2_fastcall

cm32_sdcc_fsmul2:
    call cm32_sdcc_fsread1
    jp m32_fsmul2_fastcall
