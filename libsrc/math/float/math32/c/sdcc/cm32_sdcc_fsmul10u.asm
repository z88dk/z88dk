
SECTION code_fp_math32

PUBLIC cm32_sdcc_fsmul10u

EXTERN cm32_sdcc_fsread1, m32_fsmul10u_fastcall

cm32_sdcc_fsmul10u:
    call cm32_sdcc_fsread1
    jp m32_fsmul10u_fastcall
