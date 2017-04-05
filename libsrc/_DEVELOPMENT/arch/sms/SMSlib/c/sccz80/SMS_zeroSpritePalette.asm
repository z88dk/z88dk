; void SMS_zeroSpritePalette(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_zeroSpritePalette

EXTERN asm_SMSlib_zeroSpritePalette

defc SMS_zeroSpritePalette = asm_SMSlib_zeroSpritePalette
