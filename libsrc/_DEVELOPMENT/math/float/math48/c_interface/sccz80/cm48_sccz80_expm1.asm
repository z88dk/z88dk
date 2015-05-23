
; double __FASTCALL__ expm1(double x)

SECTION code_fp_math48

PUBLIC cm48_sccz80_expm1

EXTERN lm48_expm1

defc cm48_sccz80_expm1 = lm48_expm1
