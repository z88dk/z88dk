; void PSGSFXPlayLoop(void *sfx,unsigned char channels)

SECTION code_clib
SECTION code_PSGlib

PUBLIC PSGSFXPlayLoop

EXTERN asm_PSGlib_SFXPlayLoop

PSGSFXPlayLoop:

   pop af
	pop bc
	pop de
	push de
	push bc
	push af

   jp asm_PSGlib_SFXPlayLoop
