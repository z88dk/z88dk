; void PSGPlayNoRepeat(void *song)

SECTION code_clib
SECTION code_PSGlib

PUBLIC _PSGPlayNoRepeat_fastcall

EXTERN asm_PSGlib_PlayNoRepeat

defc _PSGPlayNoRepeat_fastcall = asm_PSGlib_PlayNoRepeat
