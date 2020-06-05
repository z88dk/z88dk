
SECTION code_fp_math32

PUBLIC cm32_sdcc_floor

EXTERN cm32_sdcc_fsread1, m32_floor_fastcall

cm32_sdcc_floor:
    call cm32_sdcc_fsread1
    jp m32_floor_fastcall
