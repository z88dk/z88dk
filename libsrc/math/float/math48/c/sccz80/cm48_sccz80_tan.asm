
; double __FASTCALL__ tan(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_tan

EXTERN am48_tan

defc cm48_sccz80_tan = am48_tan
