; void PSGSFXPlayLoop(void *sfx,unsigned char channels)

SECTION code_clib
SECTION code_PSGlib

PUBLIC PSGSFXPlayLoop_callee

EXTERN asm_PSGlib_SFXPlayLoop

PSGSFXPlayLoop_callee:

   pop af
   pop bc
   pop de
   push af

   jp asm_PSGlib_SFXPlayLoop
