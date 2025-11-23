
; double __FASTCALL__ trunc(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_trunc

EXTERN am48_trunc

defc cm48_sccz80_trunc = am48_trunc
