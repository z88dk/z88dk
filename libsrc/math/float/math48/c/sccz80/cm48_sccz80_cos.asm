
; double __FASTCALL__ cos(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_cos

EXTERN am48_cos

defc cm48_sccz80_cos = am48_cos
