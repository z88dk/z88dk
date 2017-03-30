; void PSGPlay(void *song)

SECTION code_clib
SECTION code_PSGlib

PUBLIC _PSGPlay_fastcall

EXTERN asm_PSGlib_Play

defc _PSGPlay_fastcall = asm_PSGlib_Play
