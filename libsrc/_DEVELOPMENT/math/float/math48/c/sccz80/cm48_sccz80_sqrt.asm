
; double __FASTCALL__ sqrt(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_sqrt

EXTERN am48_sqrt

defc cm48_sccz80_sqrt = am48_sqrt
