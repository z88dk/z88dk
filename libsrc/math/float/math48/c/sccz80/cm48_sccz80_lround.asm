
; double __FASTCALL__ lround(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_lround

EXTERN am48_lround

defc cm48_sccz80_lround = am48_lround
