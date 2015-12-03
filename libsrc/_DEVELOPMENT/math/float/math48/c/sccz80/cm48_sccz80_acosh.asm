
; double __FASTCALL__ acosh(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_acosh

EXTERN am48_acosh

defc cm48_sccz80_acosh = am48_acosh
