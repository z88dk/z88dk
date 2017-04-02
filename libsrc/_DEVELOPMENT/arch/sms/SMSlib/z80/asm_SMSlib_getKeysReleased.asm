; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_getKeysReleased

EXTERN _KeysStatus, _PreviousKeysStatus

asm_SMSlib_getKeysReleased:

   ; unsigned int SMS_getKeysReleased (void)
   ;
   ; exit : hl = keys released
   ;
   ; uses : af, hl

   ld hl,(_PreviousKeysStatus)
   
   ld a,(_KeysStatus)
   cpl
   and l
   ld l,a
   
   ld a,(_KeysStatus+1)
   cpl
   and h
   ld h,a
   
   ret
