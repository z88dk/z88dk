; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC asm_SMS_getKeysHeld

EXTERN _KeysStatus, _PreviousKeysStatus

asm_SMS_getKeysHeld:

   ; unsigned int SMS_getKeysHeld (void)
   ;
   ; exit : hl = keys held
   ;
   ; uses : af, hl

   ld hl,(_KeysStatus)
   
   ld a,(_PreviousKeysStatus)
   and l
   ld l,a
   
   ld a,(_PreviousKeysStatus+1)
   and h
   ld h,a
   
   ret
