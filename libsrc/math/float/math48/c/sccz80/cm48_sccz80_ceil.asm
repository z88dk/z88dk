
; double __FASTCALL__ ceil(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_ceil

EXTERN am48_ceil

defc cm48_sccz80_ceil = am48_ceil
