; **************************************************
; PSGlib - C programming library for the SEGA PSG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "PSGlib_private.inc"

SECTION code_clib
SECTION code_PSGlib

PUBLIC asm_PSGlib_Stop

EXTERN _PSGMusicStatus, _PSGChannel2SFX, _PSGChannel3SFX

asm_PSGlib_Stop:

   ; void PSGStop (void)
   ; stops the music (leaving the SFX on, if it's playing)
   ;
   ; uses  : af
   
   ld a,(_PSGMusicStatus)
   or a
   ret z
   
   ld a,PSGLatch|PSGChannel0|PSGVolumeData|0x0f    ; // latch channel 0, volume=0xF (silent)
   out (PSGPort),a
   
   ld a,PSGLatch|PSGChannel1|PSGVolumeData|0x0f    ; // latch channel 1, volume=0xF (silent)
   out (PSGPort),a

   ld a,(_PSGChannel2SFX)
   
   or a
   jr z, skip00
   
   ld a,PSGLatch|PSGChannel2|PSGVolumeData|0x0f    ; // latch channel 2, volume=0xF (silent)
   out (PSGPort),a

skip00:

   ld a,(_PSGChannel3SFX)
   
   or a
   jr z, skip01
   
   ld a,PSGLatch|PSGChannel3|PSGVolumeData|0x0f    ; // latch channel 3, volume=0xF (silent)
   out (PSGPort),a

skip01:

   ld a,PSG_STOPPED
   ld (_PSGMusicStatus),a
   
   ret
