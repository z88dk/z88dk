; void PSGPlay(void *song)

SECTION code_clib
SECTION code_PSGlib

PUBLIC _PSGPlay

EXTERN asm_PSGlib_Play

_PSGPlay:

   pop af
   pop hl
   push hl
   push af

   jp asm_PSGlib_Play
