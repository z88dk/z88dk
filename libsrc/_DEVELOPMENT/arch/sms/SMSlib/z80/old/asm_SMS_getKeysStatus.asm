; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC asm_SMS_getKeysStatus

EXTERN _KeysStatus

asm_SMS_getKeysStatus:

   ; unsigned int SMS_getKeysStatus (void)
   ;
   ; exit : hl = (_KeysStatus)
   ;
   ; uses : hl

   ld hl,(_KeysStatus)
   ret
