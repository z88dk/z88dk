
; double __FASTCALL__ expm1(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_expm1

EXTERN am48_expm1

defc cm48_sccz80_expm1 = am48_expm1
