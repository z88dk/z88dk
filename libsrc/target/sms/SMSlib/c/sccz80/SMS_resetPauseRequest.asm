; void SMS_resetPauseRequest(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_resetPauseRequest

EXTERN asm_SMSlib_resetPauseRequest

defc SMS_resetPauseRequest = asm_SMSlib_resetPauseRequest

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _SMS_resetPauseRequest
defc _SMS_resetPauseRequest = SMS_resetPauseRequest
ENDIF

