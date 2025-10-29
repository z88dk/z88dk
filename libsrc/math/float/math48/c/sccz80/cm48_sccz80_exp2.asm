
; double __FASTCALL__ exp2(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_exp2

EXTERN am48_exp2

defc cm48_sccz80_exp2 = am48_exp2
