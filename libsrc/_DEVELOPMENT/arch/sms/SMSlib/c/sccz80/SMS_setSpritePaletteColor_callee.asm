; void SMS_setSpritePaletteColor(unsigned char entry,unsigned char color)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_setSpritePaletteColor_callee

EXTERN asm_SMSlib_setSpritePaletteColor

SMS_setSpritePaletteColor_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   ld a,c
   jp asm_SMSlib_setSpritePaletteColor
