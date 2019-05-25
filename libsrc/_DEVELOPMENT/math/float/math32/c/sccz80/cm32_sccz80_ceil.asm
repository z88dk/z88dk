
; float ceilf(float number)

SECTION code_clib
SECTION code_fp_math32

PUBLIC cm32_sccz80_ceilf
EXTERN m32_ceilf

defc cm32_sccz80_ceilf = m32_ceilf
