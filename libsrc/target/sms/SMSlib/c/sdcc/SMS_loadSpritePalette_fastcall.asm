; void SMS_loadSpritePalette(void *palette)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_loadSpritePalette_fastcall

EXTERN asm_SMSlib_loadSpritePalette

defc _SMS_loadSpritePalette_fastcall = asm_SMSlib_loadSpritePalette
