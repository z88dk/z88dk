
SECTION code_clib
SECTION code_fp_math48

PUBLIC _nearbyint

EXTERN cm48_sdcciy_nearbyint

defc _nearbyint = cm48_sdcciy_nearbyint
