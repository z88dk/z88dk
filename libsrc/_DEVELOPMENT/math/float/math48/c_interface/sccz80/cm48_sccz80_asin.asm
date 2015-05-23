
; double __FASTCALL__ asin(double x)

SECTION code_fp_math48

PUBLIC cm48_sccz80_asin

EXTERN lm48_asin

defc cm48_sccz80_asin = lm48_asin
