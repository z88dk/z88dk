
; double __FASTCALL__ cbrt(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_cbrt

EXTERN am48_cbrt

defc cm48_sccz80_cbrt = am48_cbrt
