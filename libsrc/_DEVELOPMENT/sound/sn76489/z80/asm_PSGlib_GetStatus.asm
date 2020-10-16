; **************************************************
; PSGlib - C programming library for the SEGA PSG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "PSGlib_private.inc"

SECTION code_clib
SECTION code_PSGlib

PUBLIC asm_PSGlib_GetStatus

EXTERN __PSGlib_MusicStatus

asm_PSGlib_GetStatus:

   ; unsigned char PSGGetStatus (void)
   ; returns the current status of music
   ;
   ; exit  :  l = music status
   ;
   ; uses  : hl

   ld hl,(__PSGlib_MusicStatus)
   ret
