
; double __FASTCALL__ acos(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_acos

EXTERN am48_acos

defc cm48_sccz80_acos = am48_acos
