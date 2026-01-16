
; double __FASTCALL__ sinh(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_sinh

EXTERN am48_sinh

defc cm48_sccz80_sinh = am48_sinh
