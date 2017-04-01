; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC asm_SMS_queryPauseRequested

EXTERN _SMS_Flags

asm_SMS_queryPauseRequested:

   ; unsigned int SMS_queryPauseRequested (void)
   ;
   ; exit : hl = 1 if paused else 0
   ;
   ; uses : af, hl
   
   ld a,(_SMS_Flags)
   and $01
   
   ld l,a
   ld h,0
   
   ret
