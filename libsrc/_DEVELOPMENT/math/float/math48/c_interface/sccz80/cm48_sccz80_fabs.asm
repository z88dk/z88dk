
; double __FASTCALL__ fabs(double x)

SECTION code_fp_math48

PUBLIC cm48_sccz80_fabs

EXTERN lm48_fabs

defc cm48_sccz80_fabs = lm48_fabs
