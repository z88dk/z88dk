; void SMS_loadSpritePalette(void *palette)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_loadSpritePalette

EXTERN asm_SMSlib_loadSpritePalette

_SMS_loadSpritePalette:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_SMSlib_loadSpritePalette
