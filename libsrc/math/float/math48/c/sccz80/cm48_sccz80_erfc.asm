
; double __FASTCALL__ erfc(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_erfc

EXTERN am48_erfc

defc cm48_sccz80_erfc = am48_erfc
