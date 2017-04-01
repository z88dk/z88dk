; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC asm_SMS_resetPauseRequest

EXTERN _SMS_Flags

asm_SMS_resetPauseRequest:

   ; void SMS_resetPauseRequest (void)
   ;
   ; uses : hl
   
   ld hl,_SMS_Flags
   res 0,(hl)
   ret
