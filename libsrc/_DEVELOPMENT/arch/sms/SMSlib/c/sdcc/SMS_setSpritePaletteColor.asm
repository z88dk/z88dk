; void SMS_setSpritePaletteColor(unsigned char entry,unsigned char color)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_setSpritePaletteColor

EXTERN asm_SMSlib_setSpritePaletteColor

_SMS_setSpritePaletteColor:

   pop af
   pop hl
   
   push hl
   push af

   ld a,h
   jp asm_SMSlib_setSpritePaletteColor
