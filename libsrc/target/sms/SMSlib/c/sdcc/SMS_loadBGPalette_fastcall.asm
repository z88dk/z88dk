; void SMS_loadBGPalette(void *palette)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_loadBGPalette_fastcall

EXTERN asm_SMSlib_loadBGPalette

defc _SMS_loadBGPalette_fastcall = asm_SMSlib_loadBGPalette
