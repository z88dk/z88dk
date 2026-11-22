
; double __FASTCALL__ sin(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_sin

EXTERN am48_sin

defc cm48_sccz80_sin = am48_sin
