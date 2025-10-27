
; double __FASTCALL__ atan(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_atan

EXTERN am48_atan

defc cm48_sccz80_atan = am48_atan
