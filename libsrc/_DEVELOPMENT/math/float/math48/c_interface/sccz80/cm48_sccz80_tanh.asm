
; double __FASTCALL__ tanh(double x)

SECTION code_fp_math48

PUBLIC cm48_sccz80_tanh

EXTERN lm48_tanh

defc cm48_sccz80_tanh = lm48_tanh
