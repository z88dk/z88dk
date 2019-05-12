
; float ceil(float number)

SECTION code_clib
SECTION code_fp_math32

PUBLIC cm32_sdcc_ceil
EXTERN m32_ceil

defc cm32_sdcc_ceil = m32_ceil
