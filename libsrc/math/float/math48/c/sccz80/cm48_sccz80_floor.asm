
; double __FASTCALL__ floor(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_floor

EXTERN am48_floor

defc cm48_sccz80_floor = am48_floor
