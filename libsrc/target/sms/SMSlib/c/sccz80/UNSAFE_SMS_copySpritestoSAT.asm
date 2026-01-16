; void UNSAFE_SMS_copySpritestoSAT(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC UNSAFE_SMS_copySpritestoSAT

EXTERN asm_UNSAFE_SMSlib_copySpritestoSAT

defc UNSAFE_SMS_copySpritestoSAT = asm_UNSAFE_SMSlib_copySpritestoSAT

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _UNSAFE_SMS_copySpritestoSAT
defc _UNSAFE_SMS_copySpritestoSAT = UNSAFE_SMS_copySpritestoSAT
ENDIF

