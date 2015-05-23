
; double __FASTCALL__ sinh(double x)

SECTION code_fp_math48

PUBLIC cm48_sccz80_sinh

EXTERN lm48_sinh

defc cm48_sccz80_sinh = lm48_sinh
