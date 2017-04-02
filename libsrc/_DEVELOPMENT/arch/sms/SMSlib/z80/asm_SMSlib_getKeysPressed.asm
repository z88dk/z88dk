; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_getKeysPressed

EXTERN _KeysStatus, _PreviousKeysStatus

asm_SMSlib_getKeysPressed:

   ; unsigned int SMS_getKeysPressed (void)
   ;
   ; exit : hl = keys pressed
   ;
   ; uses : af, hl

   ld hl,(_KeysStatus)
   
   ld a,(_PreviousKeysStatus)
   cpl
   and l
   ld l,a
   
   ld a,(_PreviousKeysStatus+1)
   cpl
   and h
   ld h,a
   
   ret
