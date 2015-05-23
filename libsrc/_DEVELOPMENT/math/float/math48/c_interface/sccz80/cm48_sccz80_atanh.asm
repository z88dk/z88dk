
; double __FASTCALL__ atanh(double x)

SECTION code_fp_math48

PUBLIC cm48_sccz80_atanh

EXTERN lm48_atanh

defc cm48_sccz80_atanh = lm48_atanh
