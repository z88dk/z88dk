
; double __FASTCALL__ log10(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_log10

EXTERN am48_log10

defc cm48_sccz80_log10 = am48_log10
