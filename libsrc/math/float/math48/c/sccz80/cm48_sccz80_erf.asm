
; double __FASTCALL__ erf(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_erf

EXTERN am48_erf

defc cm48_sccz80_erf = am48_erf
