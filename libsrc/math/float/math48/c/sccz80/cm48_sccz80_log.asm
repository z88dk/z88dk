
; double __FASTCALL__ log(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_log

EXTERN am48_log

defc cm48_sccz80_log = am48_log
