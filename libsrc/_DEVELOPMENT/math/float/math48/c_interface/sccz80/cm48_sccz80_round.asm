
; double __FASTCALL__ round(double x)

SECTION code_fp_math48

PUBLIC cm48_sccz80_round

EXTERN lm48_round

defc cm48_sccz80_round = lm48_round
