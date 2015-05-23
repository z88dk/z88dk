
; double __FASTCALL__ erfc(double x)

SECTION code_fp_math48

PUBLIC cm48_sccz80_erfc

EXTERN lm48_erfc

defc cm48_sccz80_erfc = lm48_erfc
