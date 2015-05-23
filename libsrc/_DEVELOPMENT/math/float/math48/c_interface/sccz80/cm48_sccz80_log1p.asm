
; double __FASTCALL__ log1p(double x)

SECTION code_fp_math48

PUBLIC cm48_sccz80_log1p

EXTERN lm48_log1p

defc cm48_sccz80_log1p = lm48_log1p
