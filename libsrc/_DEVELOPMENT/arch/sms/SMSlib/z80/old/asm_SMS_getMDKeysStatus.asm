; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC asm_SMS_getMDKeysStatus

EXTERN _MDKeysStatus

asm_SMS_getMDKeysStatus:

   ; unsigned int SMS_getMDKeysStatus (void)
   ;
   ; exit : hl = (_MDKeysStatus)
   ;
   ; uses : hl

   ld hl,(_MDKeysStatus)
   ret
