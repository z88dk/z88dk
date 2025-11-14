; void SMS_zeroSpritePalette(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_zeroSpritePalette

EXTERN asm_SMSlib_zeroSpritePalette

defc _SMS_zeroSpritePalette = asm_SMSlib_zeroSpritePalette
