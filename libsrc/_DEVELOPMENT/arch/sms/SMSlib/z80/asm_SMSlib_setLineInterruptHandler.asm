; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_setLineInterruptHandler

EXTERN _SMS_theLineInterruptHandler

asm_SMSlib_setLineInterruptHandler:

   ; void SMS_setLineInterruptHandler (void (*theHandlerFunction)(void))
   ;
   ; enter : hl = void (*theHandlerFunction)(void)
   ;
   ; uses  : none

   ld (_SMS_theLineInterruptHandler),hl
   ret
