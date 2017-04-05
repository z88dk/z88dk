; void SMS_setBGPaletteColor(unsigned char entry,unsigned char color)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_setBGPaletteColor

EXTERN asm_SMSlib_setBGPaletteColor

_SMS_setBGPaletteColor:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   ld a,c
   jp asm_SMSlib_setBGPaletteColor
