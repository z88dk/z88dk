
; float floorf(float number)

SECTION code_clib
SECTION code_fp_math32

PUBLIC cm32_sccz80_floorf
EXTERN m32_floorf

defc cm32_sccz80_floorf = m32_floorf
