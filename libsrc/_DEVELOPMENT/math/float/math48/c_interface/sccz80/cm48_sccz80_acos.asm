
; double __FASTCALL__ acos(double x)

SECTION code_fp_math48

PUBLIC cm48_sccz80_acos

EXTERN lm48_acos

defc cm48_sccz80_acos = lm48_acos
