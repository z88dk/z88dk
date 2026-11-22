; void SMS_loadBGPalette(void *palette)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_loadBGPalette

EXTERN asm_SMSlib_loadBGPalette

_SMS_loadBGPalette:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_SMSlib_loadBGPalette
