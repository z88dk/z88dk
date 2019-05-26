
; float ceilf(float number)

SECTION code_clib
SECTION code_fp_math32

PUBLIC cm32_sdcc_ceilf
EXTERN m32_ceilf

defc cm32_sdcc_ceilf = m32_ceilf
