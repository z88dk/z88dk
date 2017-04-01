; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC asm_SMS_waitForVBlank

EXTERN _SMS_Flags

include "../SMSlib_private.inc"

asm_SMS_waitForVBlank:

   ; void SMS_waitForVBlank (void)
   ;
   ; uses : f, hl
   
   ld hl,_SMSFlags
   res 7,(hl)
   
loop:

   bit 7,(hl)
   jr z, loop
   
   ret
