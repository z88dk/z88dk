
; double __FASTCALL__ nearbyint(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_nearbyint

EXTERN am48_nearbyint

defc cm48_sccz80_nearbyint = am48_nearbyint
