
; double __FASTCALL__ fabs(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_fabs

EXTERN am48_fabs

defc cm48_sccz80_fabs = am48_fabs
