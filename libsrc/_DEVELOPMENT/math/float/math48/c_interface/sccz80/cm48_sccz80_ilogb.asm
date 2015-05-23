
; int __FASTCALL__ ilogb(double x)

SECTION code_fp_math48

PUBLIC cm48_sccz80_ilogb

EXTERN lm48_ilogb

defc cm48_sccz80_ilogb = lm48_ilogb
