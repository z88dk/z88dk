; **************************************************
; PSGlib - C programming library for the SEGA PSG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "PSGlib_private.inc"

SECTION code_clib
SECTION code_PSGlib

PUBLIC asm_PSGlib_PlayNoRepeat

EXTERN asm_PSGlib_Play, __PSGlib_LoopFlag

asm_PSGlib_PlayNoRepeat:

   ; void PSGPlayNoRepeat (void *song)
   ; receives the address of the PSG to start playing (once)
   ;
   ; enter : hl = void *song
   ;
   ; uses  : af

   call asm_PSGlib_Play

   xor a
   ld (__PSGlib_LoopFlag),a
   
   ret
