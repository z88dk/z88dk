
; double __FASTCALL__ tgamma(double x)

SECTION code_fp_math48

PUBLIC cm48_sccz80_tgamma

EXTERN am48_tgamma

defc cm48_sccz80_tgamma = am48_tgamma
