
SECTION code_clib
SECTION code_fp_math48

PUBLIC _fma

EXTERN cm48_sdcciy_fma

defc _fma = cm48_sdcciy_fma
