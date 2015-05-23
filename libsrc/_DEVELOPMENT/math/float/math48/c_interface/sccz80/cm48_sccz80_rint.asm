
; double __FASTCALL__ rint(double x)

SECTION code_fp_math48

PUBLIC cm48_sccz80_rint

EXTERN lm48_rint

defc cm48_sccz80_rint = lm48_rint
