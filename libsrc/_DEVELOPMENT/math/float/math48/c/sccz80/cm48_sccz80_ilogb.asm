
; int __FASTCALL__ ilogb(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_ilogb

EXTERN am48_ilogb

defc cm48_sccz80_ilogb = am48_ilogb
