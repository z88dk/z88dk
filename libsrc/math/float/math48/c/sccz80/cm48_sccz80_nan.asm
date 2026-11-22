
; double __FASTCALL__ nan(const char *tagp)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_nan

EXTERN am48_nan

defc cm48_sccz80_nan = am48_nan
