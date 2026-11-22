; void PSGPlayNoRepeat(void *song)

SECTION code_clib
SECTION code_PSGlib

PUBLIC _PSGPlayNoRepeat

EXTERN asm_PSGlib_PlayNoRepeat

_PSGPlayNoRepeat:

   pop af
   pop hl
   push hl
   push af

   jp asm_PSGlib_PlayNoRepeat
