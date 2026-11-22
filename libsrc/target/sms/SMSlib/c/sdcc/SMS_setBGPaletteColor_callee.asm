; void SMS_setBGPaletteColor(unsigned char entry,unsigned char color)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_setBGPaletteColor_callee

EXTERN asm_SMSlib_setBGPaletteColor

_SMS_setBGPaletteColor_callee:

   pop hl
	ex (sp),hl
	
	ld a,h
   jp asm_SMSlib_setBGPaletteColor
