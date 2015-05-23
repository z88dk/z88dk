
; double __FASTCALL__ nearbyint(double x)

SECTION code_fp_math48

PUBLIC cm48_sccz80_nearbyint

EXTERN lm48_nearbyint

defc cm48_sccz80_nearbyint = lm48_nearbyint
