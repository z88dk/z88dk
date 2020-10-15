; void PSGPlayNoRepeat(void *song)

SECTION code_clib
SECTION code_PSGlib

PUBLIC PSGPlayNoRepeat

EXTERN asm_PSGlib_PlayNoRepeat

defc PSGPlayNoRepeat = asm_PSGlib_PlayNoRepeat
