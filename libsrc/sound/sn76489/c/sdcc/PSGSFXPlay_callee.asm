; void PSGSFXPlay(void *sfx,unsigned char channels)

SECTION code_clib
SECTION code_PSGlib

PUBLIC _PSGSFXPlay_callee

EXTERN asm_PSGlib_SFXPlay

_PSGSFXPlay_callee:

   pop hl
   pop de
   dec sp
   ex (sp),hl
   ld c,h

   jp asm_PSGlib_SFXPlay
