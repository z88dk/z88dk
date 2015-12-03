
SECTION code_clib
SECTION code_fp_math48

PUBLIC _round

EXTERN cm48_sdcciy_round

defc _round = cm48_sdcciy_round
