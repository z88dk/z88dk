
; double __FASTCALL__ exp(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_exp

EXTERN am48_exp

defc cm48_sccz80_exp = am48_exp
