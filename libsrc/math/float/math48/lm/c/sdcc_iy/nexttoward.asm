
SECTION code_clib
SECTION code_fp_math48

PUBLIC _nexttoward

EXTERN cm48_sdcciy_nexttoward

defc _nexttoward = cm48_sdcciy_nexttoward
