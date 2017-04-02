; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_getMDKeysReleased

EXTERN _MDKeysStatus, _PreviousMDKeysStatus

asm_SMSlib_getMDKeysReleased:

   ; unsigned int SMS_getMDKeysReleased (void)
   ;
   ; exit : hl = MD keys released
   ;
   ; uses : af, hl

   ld hl,(_PreviousMDKeysStatus)
   
   ld a,(_MDKeysStatus)
   cpl
   and l
   ld l,a
   
   ld a,(_MDKeysStatus+1)
   cpl
   and h
   ld h,a
   
   ret
