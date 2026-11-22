; void PSGSFXPlay(void *sfx,unsigned char channels)

SECTION code_clib
SECTION code_PSGlib

PUBLIC PSGSFXPlay_callee

EXTERN asm_PSGlib_SFXPlay

PSGSFXPlay_callee:

   pop af
   pop bc
   pop de
   push af

   jp asm_PSGlib_SFXPlay

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _PSGSFXPlay_callee
defc _PSGSFXPlay_callee = PSGSFXPlay_callee
ENDIF

