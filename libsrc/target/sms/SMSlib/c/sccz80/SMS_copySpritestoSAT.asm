; void SMS_copySpritestoSAT(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_copySpritestoSAT

EXTERN asm_SMSlib_copySpritestoSAT

defc SMS_copySpritestoSAT = asm_SMSlib_copySpritestoSAT

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _SMS_copySpritestoSAT
defc _SMS_copySpritestoSAT = SMS_copySpritestoSAT
ENDIF

