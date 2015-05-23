
; double __FASTCALL__ lround(double x)

SECTION code_fp_math48

PUBLIC cm48_sccz80_lround

EXTERN lm48_lround

defc cm48_sccz80_lround = lm48_lround
