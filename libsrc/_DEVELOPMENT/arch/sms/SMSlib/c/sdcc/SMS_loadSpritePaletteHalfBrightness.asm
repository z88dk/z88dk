; void SMS_loadSpritePaletteHalfBrightness(void *palette)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_loadSpritePaletteHalfBrightness

EXTERN asm_SMSlib_loadSpritePaletteHalfBrightness

_SMS_loadSpritePaletteHalfBrightness:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_SMSlib_loadSpritePaletteHalfBrightness
