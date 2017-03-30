; void PSGSFXPlayLoop(void *sfx,unsigned char channels)

SECTION code_clib
SECTION code_PSGlib

PUBLIC _PSGSFXPlayLoop

EXTERN asm_PSGlib_SFXPlayLoop

_PSGSFXPlayLoop:

   pop af
	pop de
	pop bc
	push bc
	push de
	push af

   jp asm_PSGlib_SFXPlayLoop
