; unsigned char SMS_queryPauseRequested(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_queryPauseRequested

EXTERN asm_SMSlib_queryPauseRequested

defc SMS_queryPauseRequested = asm_SMSlib_queryPauseRequested

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _SMS_queryPauseRequested
defc _SMS_queryPauseRequested = SMS_queryPauseRequested
ENDIF

