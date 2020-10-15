; **************************************************
; PSGlib - C programming library for the SEGA PSG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "PSGlib_private.inc"

SECTION code_clib
SECTION code_PSGlib

PUBLIC asm_PSGlib_SFXStop

EXTERN __PSGlib_SFXStatus, __PSGlib_Channel2SFX, __PSGlib_Channel3SFX

EXTERN __PSGlib_MusicStatus, __PSGlib_MusicVolumeAttenuation, __PSGlib_Chan2Volume, __PSGlib_Chan3Volume
EXTERN __PSGlib_Chan2LowTone, __PSGlib_Chan2HighTone, __PSGlib_Chan3LowTone

asm_PSGlib_SFXStop:

   ; void PSGSFXStop (void)
   ; stops the SFX (leaving the music on, if it's playing)
   ;
   ; uses : af, hl
   
   ld a,(__PSGlib_SFXStatus)
   or a
   ret z
   
   ld hl,(__PSGlib_MusicVolumeAttenuation)
   ld a,(__PSGlib_MusicStatus)
   ld h,a
   
   ; l = __PSGlib_MusicVolumeAttenuation
   ; h = __PSGlib_MusicStatus
   
   ld a,(__PSGlib_Channel2SFX)
   or a
   jr z, skipchan2

   inc h
   dec h
   jr z, silchan2
   
   ld a,(__PSGlib_Chan2LowTone)
   and 0x0f
   or PSGLatch|PSGChannel2
   out (PSGPort),a
   
   ld a,(__PSGlib_Chan2HighTone)
   and 0x3f
   out (PSGPort),a
   
   ld a,(__PSGlib_Chan2Volume)
   
   add a,l
   cp 16
   
   jr c, outchan2

silchan2:

   ld a,15

outchan2:

   or PSGLatch|PSGChannel3|PSGVolumeData
   out (PSGPort),a

   ld a,PSG_STOPPED
   ld (__PSGlib_Channel2SFX),a
   
skipchan2:

   ld a,(__PSGlib_Channel3SFX)
   or a
   jr z, skipchan3

   inc h
   dec h
   jr z, silchan3

   ld a,(__PSGlib_Chan3LowTone)
   and 0x0f
   or PSGLatch|PSGChannel3
   out (PSGPort),a
   
   ld a,(__PSGlib_Chan3Volume)
   
   add a,l
   cp 16
   
   jr c, outchan3

silchan3:

   ld a,15

outchan3:

   or PSGLatch|PSGChannel3|PSGVolumeData
   out (PSGPort),a

   ld a,PSG_STOPPED
   ld (__PSGlib_Channel3SFX),a
   
skipchan3:

   ld a,PSG_STOPPED
   ld (__PSGlib_SFXStatus),a
   
   ret
