; **************************************************
; PSGlib - C programming library for the SEGA PSG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "PSGlib_private.inc"

SECTION code_clib
SECTION code_PSGlib

PUBLIC asm_PSGlib_SFXStop

EXTERN _PSGSFXStatus, _PSGChannel2SFX, _PSGChannel3SFX

EXTERN _PSGMusicStatus, _PSGMusicVolumeAttenuation, _PSGChan2Volume, _PSGChan3Volume
EXTERN _PSGChan2LowTone, _PSGChan2HighTone, _PSGChan3LowTone

asm_PSGlib_SFXStop:

   ; void PSGSFXStop (void)
   ; stops the SFX (leaving the music on, if it's playing)
   ;
   ; uses : af, hl
   
   ld a,(_PSGSFXStatus)
   or a
   ret z
   
   ld hl,(_PSGMusicVolumeAttenuation)
   ld a,(_PSGMusicStatus)
   ld h,a
   
   ; l = _PSGMusicVolumeAttenuation
   ; h = _PSGMusicStatus
   
   ld a,(_PSGChannel2SFX)
   or a
   jr z, skipchan2

   inc h
   dec h
   jr z, silchan2
   
   ld a,(_PSGChan2LowTone)
   and 0x0f
   or PSGLatch|PSGChannel2
   out (PSGPort),a
   
   ld a,(_PSGChan2HighTone)
   and 0x3f
   out (PSGPort),a
   
   ld a,(_PSGChan2Volume)
   
   add a,l
   cp 16
   
   jr c, outchan2

silchan2:

   ld a,15

outchan2:

   or PSGLatch|PSGChannel3|PSGVolumeData
   out (PSGPort),a

   ld a,PSG_STOPPED
   ld (_PSGChannel2SFX),a
   
skipchan2:

   ld a,(_PSGChannel3SFX)
   or a
   jr z, skipchan3

   inc h
   dec h
   jr z, silchan3

   ld a,(_PSGChan3LowTone)
   and 0x0f
   or PSGLatch|PSGChannel3
   out (PSGPort),a
   
   ld a,(_PSGChan3Volume)
   
   add a,l
   cp 16
   
   jr c, outchan3

silchan3:

   ld a,15

outchan3:

   or PSGLatch|PSGChannel3|PSGVolumeData
   out (PSGPort),a

   ld a,PSG_STOPPED
   ld (_PSGChannel3SFX),a
   
skipchan3:

   ld a,PSG_STOPPED
   ld (_PSGSFXStatus),a
   
   ret
