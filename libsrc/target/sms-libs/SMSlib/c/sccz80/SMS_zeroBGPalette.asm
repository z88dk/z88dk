; void SMS_zeroBGPalette(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_zeroBGPalette

EXTERN asm_SMSlib_zeroBGPalette

defc SMS_zeroBGPalette = asm_SMSlib_zeroBGPalette
