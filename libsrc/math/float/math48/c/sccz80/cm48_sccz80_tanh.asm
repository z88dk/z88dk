
; double __FASTCALL__ tanh(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_tanh

EXTERN am48_tanh

defc cm48_sccz80_tanh = am48_tanh
