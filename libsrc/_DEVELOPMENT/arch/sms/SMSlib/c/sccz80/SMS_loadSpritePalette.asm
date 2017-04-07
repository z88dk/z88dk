; void SMS_loadSpritePalette(void *palette)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_loadSpritePalette

EXTERN asm_SMSlib_loadSpritePalette

defc SMS_loadSpritePalette = asm_SMSlib_loadSpritePalette
