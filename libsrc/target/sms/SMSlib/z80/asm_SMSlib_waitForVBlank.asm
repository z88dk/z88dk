; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_waitForVBlank

EXTERN __SMSlib_VDPBlank

asm_SMSlib_waitForVBlank:

   ; void SMS_waitForVBlank (void)
   ;
   ; uses : af, hl
   
   ld hl,__SMSlib_VDPBlank
   ld (hl),0
   
loop:

   ld a,(hl)
	or a
   jr z, loop
   
   ret
