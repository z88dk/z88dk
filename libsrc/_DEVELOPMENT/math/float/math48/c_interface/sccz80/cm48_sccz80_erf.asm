
; double __FASTCALL__ erf(double x)

SECTION code_fp_math48

PUBLIC cm48_sccz80_erf

EXTERN lm48_erf

defc cm48_sccz80_erf = lm48_erf
