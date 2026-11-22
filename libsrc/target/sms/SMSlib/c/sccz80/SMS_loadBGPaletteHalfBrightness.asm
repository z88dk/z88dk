; void SMS_loadBGPaletteHalfBrightness(void *palette)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_loadBGPaletteHalfBrightness

EXTERN asm_SMSlib_loadBGPaletteHalfBrightness

defc SMS_loadBGPaletteHalfBrightness = asm_SMSlib_loadBGPaletteHalfBrightness

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _SMS_loadBGPaletteHalfBrightness
defc _SMS_loadBGPaletteHalfBrightness = SMS_loadBGPaletteHalfBrightness
ENDIF

