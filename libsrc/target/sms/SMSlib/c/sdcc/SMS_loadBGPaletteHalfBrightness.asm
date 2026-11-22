; void SMS_loadBGPaletteHalfBrightness(void *palette)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_loadBGPaletteHalfBrightness

EXTERN asm_SMSlib_loadBGPaletteHalfBrightness

_SMS_loadBGPaletteHalfBrightness:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_SMSlib_loadBGPaletteHalfBrightness
