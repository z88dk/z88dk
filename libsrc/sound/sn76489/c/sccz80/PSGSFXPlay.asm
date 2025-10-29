; void PSGSFXPlay(void *sfx,unsigned char channels)

SECTION code_clib
SECTION code_PSGlib

PUBLIC PSGSFXPlay

EXTERN asm_PSGlib_SFXPlay

PSGSFXPlay:

   pop af
	pop bc
	pop de
	push de
	push bc
	push af

   jp asm_PSGlib_SFXPlay

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _PSGSFXPlay
defc _PSGSFXPlay = PSGSFXPlay
ENDIF

