
; double __FASTCALL__ floor(double x)

SECTION code_fp_math48

PUBLIC cm48_sccz80_floor

EXTERN lm48_floor

defc cm48_sccz80_floor = lm48_floor
