
; float floor(float number)

SECTION code_clib
SECTION code_fp_math32

PUBLIC cm32_sccz80_floor
EXTERN m32_floor

defc cm32_sccz80_floor = m32_floor
