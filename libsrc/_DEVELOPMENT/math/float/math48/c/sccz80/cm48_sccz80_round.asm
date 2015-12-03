
; double __FASTCALL__ round(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_round

EXTERN am48_round

defc cm48_sccz80_round = am48_round
