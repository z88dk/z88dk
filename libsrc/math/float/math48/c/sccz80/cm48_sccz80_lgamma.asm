
; double __FASTCALL__ lgamma(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_lgamma

EXTERN am48_lgamma

defc cm48_sccz80_lgamma = am48_lgamma
