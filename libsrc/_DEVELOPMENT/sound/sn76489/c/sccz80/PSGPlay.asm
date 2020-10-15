; void PSGPlay(void *song)

SECTION code_clib
SECTION code_PSGlib

PUBLIC PSGPlay

EXTERN asm_PSGlib_Play

defc PSGPlay = asm_PSGlib_Play
