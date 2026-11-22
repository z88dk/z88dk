
; double __FASTCALL__ log1p(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_log1p

EXTERN am48_log1p

defc cm48_sccz80_log1p = am48_log1p
