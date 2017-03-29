; **************************************************
; PSGlib - C programming library for the SEGA PSG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "PSGlib_private.inc"

SECTION code_clib
SECTION code_PSGlib

PUBLIC asm_PSGlib_SilenceChannels

asm_PSGlib_SilenceChannels:

   ; void PSGSilenceChannels (void)
   ; silence all the PSG channels
   ;
   ; uses  : af
   
   ld a,PSGLatch|PSGChannel0|PSGVolumeData|0x0f    ; // latch channel 0, volume=0xF (silent)
   out (PSGPort),a
   
   ld a,PSGLatch|PSGChannel1|PSGVolumeData|0x0f    ; // latch channel 1, volume=0xF (silent)
   out (PSGPort),a
   
   ld a,PSGLatch|PSGChannel2|PSGVolumeData|0x0f    ; // latch channel 2, volume=0xF (silent)
   out (PSGPort),a
   
   ld a,PSGLatch|PSGChannel3|PSGVolumeData|0x0f    ; // latch channel 3, volume=0xF (silent)
   out (PSGPort),a
   
   ret
