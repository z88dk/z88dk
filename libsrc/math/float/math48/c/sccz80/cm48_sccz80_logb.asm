
; double __FASTCALL__ logb(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_logb

EXTERN am48_logb

defc cm48_sccz80_logb = am48_logb
