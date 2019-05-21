
; float fabs(float number)

SECTION code_clib
SECTION code_fp_math32

PUBLIC cm32_sdcc_fabs
EXTERN m32_fabs

defc cm32_sdcc_fabs = m32_fabs
