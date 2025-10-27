
; double __FASTCALL__ log2(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_log2

EXTERN am48_log2

defc cm48_sccz80_log2 = am48_log2
