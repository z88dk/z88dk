; **************************************************
; PSGlib - C programming library for the SEGA PSG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "PSGlib_private.inc"

SECTION code_clib
SECTION code_PSGlib

PUBLIC asm_PSGlib_SFXCancelLoop

EXTERN _PSGSFXLoopFlag

asm_PSGlib_SFXCancelLoop:

   ; void PSGCancelLoop (void)
   ; sets the currently looping music to no more loops after the current
   ;
   ; uses  : af

   xor a
   ld (_PSGSFXLoopFlag),a
   
   ret
