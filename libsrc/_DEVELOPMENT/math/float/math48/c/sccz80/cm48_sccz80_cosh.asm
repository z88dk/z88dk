
; double __FASTCALL__ cosh(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_cosh

EXTERN am48_cosh

defc cm48_sccz80_cosh = am48_cosh
