
; double __FASTCALL__ lgamma(double x)

SECTION code_fp_math48

PUBLIC cm48_sccz80_lgamma

EXTERN lm48_lgamma

defc cm48_sccz80_lgamma = lm48_lgamma
