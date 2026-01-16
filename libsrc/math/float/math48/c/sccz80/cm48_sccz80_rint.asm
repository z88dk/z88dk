
; double __FASTCALL__ rint(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_rint

EXTERN am48_rint

defc cm48_sccz80_rint = am48_rint
