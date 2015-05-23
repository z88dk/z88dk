
; double __FASTCALL__ logb(double x)

SECTION code_fp_math48

PUBLIC cm48_sccz80_logb

EXTERN lm48_logb

defc cm48_sccz80_logb = lm48_logb
