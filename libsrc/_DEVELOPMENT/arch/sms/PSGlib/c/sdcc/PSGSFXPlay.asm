; void PSGSFXPlay(void *sfx,unsigned char channels)

SECTION code_clib
SECTION code_PSGlib

PUBLIC _PSGSFXPlay

EXTERN asm_PSGlib_SFXPlay

_PSGSFXPlay:

   pop af
	pop de
	pop bc
	push bc
	push de
	push af

   jp asm_PSGlib_SFXPlay
