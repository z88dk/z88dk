; void SMS_setBGPaletteColor(unsigned char entry,unsigned char color)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_setBGPaletteColor_callee

EXTERN asm_SMSlib_setBGPaletteColor

SMS_setBGPaletteColor_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   ld a,c
   jp asm_SMSlib_setBGPaletteColor
