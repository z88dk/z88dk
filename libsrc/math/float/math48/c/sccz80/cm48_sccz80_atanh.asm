
; double __FASTCALL__ atanh(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_atanh

EXTERN am48_atanh

defc cm48_sccz80_atanh = am48_atanh
