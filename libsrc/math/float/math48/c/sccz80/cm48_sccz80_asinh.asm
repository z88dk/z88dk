
; double __FASTCALL__ asinh(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_asinh

EXTERN am48_asinh

defc cm48_sccz80_asinh = am48_asinh
