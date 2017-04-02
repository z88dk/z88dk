; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_waitForVBlank

EXTERN _VDPBlank

asm_SMSlib_waitForVBlank:

   ; void SMS_waitForVBlank (void)
   ;
   ; uses : af, hl
   
   ld hl,_VDPBlank
   ld (hl),0
   
loop:

   ld a,(hl)
	or a
   jr z, loop
   
   ret
