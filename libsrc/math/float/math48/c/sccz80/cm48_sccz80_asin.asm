
; double __FASTCALL__ asin(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_asin

EXTERN am48_asin

defc cm48_sccz80_asin = am48_asin
