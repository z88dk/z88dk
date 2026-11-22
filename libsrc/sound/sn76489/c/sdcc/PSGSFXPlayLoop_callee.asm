; void PSGSFXPlayLoop(void *sfx,unsigned char channels)

SECTION code_clib
SECTION code_PSGlib

PUBLIC _PSGSFXPlayLoop_callee

EXTERN asm_PSGlib_SFXPlayLoop

_PSGSFXPlayLoop_callee:

   pop hl
   pop de
   dec sp
   ex (sp),hl
   ld c,h

   jp asm_PSGlib_SFXPlayLoop
