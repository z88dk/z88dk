
SECTION code_clib
SECTION code_fp_math48

PUBLIC dread1, dread2

EXTERN cm48_sccz80p_dread1, cm48_sccz80p_dread2

defc dread1 = cm48_sccz80p_dread1
defc dread2 = cm48_sccz80p_dread2
