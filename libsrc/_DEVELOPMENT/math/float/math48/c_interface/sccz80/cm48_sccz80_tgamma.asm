
; double __FASTCALL__ tgamma(double x)

SECTION code_fp_math48

PUBLIC cm48_sccz80_tgamma

EXTERN lm48_tgamma

defc cm48_sccz80_tgamma = lm48_tgamma
