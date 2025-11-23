; void SMS_waitForVBlank(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_waitForVBlank

EXTERN asm_SMSlib_waitForVBlank

defc SMS_waitForVBlank = asm_SMSlib_waitForVBlank

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _SMS_waitForVBlank
defc _SMS_waitForVBlank = SMS_waitForVBlank
ENDIF

