; **************************************************
; PSGlib - C programming library for the SEGA PSG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "PSGlib_private.inc"

SECTION code_clib
SECTION code_PSGlib

PUBLIC asm_PSGlib_SetMusicVolumeAttenuation

EXTERN __PSGlib_MusicStatus, __PSGlib_Channel2SFX, __PSGlib_Channel3SFX

EXTERN __PSGlib_MusicVolumeAttenuation
EXTERN __PSGlib_Chan0Volume, __PSGlib_Chan1Volume, __PSGlib_Chan2Volume, __PSGlib_Chan3Volume

asm_PSGlib_SetMusicVolumeAttenuation:

   ; void PSGSetMusicVolumeAttenutation (void)
   ; sets the volume attenuation for the music (0-15)
   ;
	; enter : l = volume attenuation (0-15)
	;
   ; uses  : af

   ld a,l
	ld (__PSGlib_MusicVolumeAttenuation),a
	
	ld a,(__PSGlib_MusicStatus)
	or a
	ret z
	
   ld a,(__PSGlib_Chan0Volume)

   add a,l
   cp 16
   
   jr c, outchan0
   ld a,15
   
outchan0:

   or PSGLatch|PSGChannel0|PSGVolumeData
   out (PSGPort),a
	
	ld a,(__PSGlib_Chan1Volume)
   
   add a,l
   cp 16
   
   jr c, outchan1
   ld a,15

outchan1:

   or PSGLatch|PSGChannel1|PSGVolumeData
   out (PSGPort),a

	ld a,(__PSGlib_Channel2SFX)
	or a
	jr nz, skipchan2

	ld a,(__PSGlib_Chan2Volume)
   
   add a,l
   cp 16
   
   jr c, outchan2
   ld a,15

outchan2:

   or PSGLatch|PSGChannel2|PSGVolumeData
   out (PSGPort),a
	
skipchan2:

   ld a,(__PSGlib_Channel3SFX)
	or a
	ret nz
	
	ld a,(__PSGlib_Chan3Volume)
   
   add a,l
   cp 16
   
   jr c, outchan3
   ld a,15

outchan3:

   or PSGLatch|PSGChannel3|PSGVolumeData
   out (PSGPort),a
	
	ret
