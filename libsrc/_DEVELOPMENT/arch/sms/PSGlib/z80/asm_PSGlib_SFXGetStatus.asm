; PSGlib - C programming library for the SEGA PSG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "PSGlib_private.inc"

SECTION code_clib
SECTION code_PSGlib

PUBLIC asm_PSGlib_SFXGetStatus

EXTERN __PSGlib_SFXStatus

asm_PSGlib_SFXGetStatus:

   ; unsigned char PSGSFXGetStatus (void)
   ; returns the current SFX status
   ;
   ; exit  :  l = current SFX status
   ;
   ; uses  : hl

   ld hl,(__PSGlib_SFXStatus)
   ret
