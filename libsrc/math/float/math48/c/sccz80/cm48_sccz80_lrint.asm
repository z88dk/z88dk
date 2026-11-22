
; long __FASTCALL__ lrint(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_lrint

EXTERN am48_lrint

defc cm48_sccz80_lrint = am48_lrint
