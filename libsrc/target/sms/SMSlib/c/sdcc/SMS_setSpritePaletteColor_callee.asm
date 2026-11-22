; void SMS_setSpritePaletteColor(unsigned char entry,unsigned char color)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_setSpritePaletteColor_callee

EXTERN asm_SMSlib_setSpritePaletteColor

_SMS_setSpritePaletteColor_callee:

   pop hl
	ex (sp),hl
	
	ld a,h
   jp asm_SMSlib_setSpritePaletteColor
