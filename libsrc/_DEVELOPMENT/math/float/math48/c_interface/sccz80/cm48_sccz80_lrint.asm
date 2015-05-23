
; long __FASTCALL__ lrint(double x)

SECTION code_fp_math48

PUBLIC cm48_sccz80_lrint

EXTERN lm48_lrint

defc cm48_sccz80_lrint = lm48_lrint
