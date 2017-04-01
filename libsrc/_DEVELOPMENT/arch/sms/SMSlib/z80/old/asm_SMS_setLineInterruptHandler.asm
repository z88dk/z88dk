; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC asm_SMS_setLineInterruptHandler

EXTERN _SMS_theLineInterruptHandler

asm_SMS_setLineInterruptHandler:

   ; void SMS_setLineInterruptHandler (void (*theHandlerFunction)(void))
   ;
   ; enter : hl = void (*theHandlerFunction)(void)
   ;
   ; uses  : none

   ld (_SMS_theLineInterruptHandler),hl
   ret
