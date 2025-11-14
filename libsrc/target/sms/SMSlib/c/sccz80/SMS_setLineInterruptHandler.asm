; void SMS_setLineInterruptHandler(void *theHandlerFunction)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_setLineInterruptHandler

EXTERN asm_SMSlib_setLineInterruptHandler

defc SMS_setLineInterruptHandler = asm_SMSlib_setLineInterruptHandler

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _SMS_setLineInterruptHandler
defc _SMS_setLineInterruptHandler = SMS_setLineInterruptHandler
ENDIF

