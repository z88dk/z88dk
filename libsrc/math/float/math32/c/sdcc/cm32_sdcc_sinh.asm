
SECTION code_fp_math32

PUBLIC cm32_sdcc_sinh

EXTERN cm32_sdcc_fsread1, _m32_sinhf

cm32_sdcc_sinh:
    call cm32_sdcc_fsread1
    jp _m32_sinhf
