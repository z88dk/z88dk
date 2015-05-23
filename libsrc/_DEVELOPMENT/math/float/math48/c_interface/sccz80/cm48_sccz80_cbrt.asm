
; double __FASTCALL__ cbrt(double x)

SECTION code_fp_math48

PUBLIC cm48_sccz80_cbrt

EXTERN lm48_cbrt

defc cm48_sccz80_cbrt = lm48_cbrt
