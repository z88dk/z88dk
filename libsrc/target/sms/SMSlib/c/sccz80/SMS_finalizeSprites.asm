; void SMS_finalizeSprites(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_finalizeSprites

EXTERN asm_SMSlib_finalizeSprites

defc SMS_finalizeSprites = asm_SMSlib_finalizeSprites

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _SMS_finalizeSprites
defc _SMS_finalizeSprites = SMS_finalizeSprites
ENDIF

