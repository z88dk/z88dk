; void SMS_setSpritePaletteColor(unsigned char entry,unsigned char color)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_setSpritePaletteColor

EXTERN asm_SMSlib_setSpritePaletteColor

SMS_setSpritePaletteColor:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   ld a,c
   jp asm_SMSlib_setSpritePaletteColor
