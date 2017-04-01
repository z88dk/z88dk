; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC asm_SMS_getMDKeysPressed

EXTERN _MDKeysStatus, _PreviousMDKeysStatus

asm_SMS_getMDKeysPressed:

   ; unsigned int SMS_getMDKeysPressed (void)
   ;
   ; exit : hl = MD keys pressed
   ;
   ; uses : af, hl

   ld hl,(_MDKeysStatus)
   
   ld a,(_PreviousMDKeysStatus)
   cpl
   and l
   ld l,a
   
   ld a,(_PreviousMDKeysStatus+1)
   cpl
   and h
   ld h,a
   
   ret
