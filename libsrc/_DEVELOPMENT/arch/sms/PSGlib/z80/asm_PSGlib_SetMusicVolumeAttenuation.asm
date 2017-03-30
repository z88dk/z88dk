; **************************************************
; PSGlib - C programming library for the SEGA PSG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "PSGlib_private.inc"

SECTION code_clib
SECTION code_PSGlib

PUBLIC asm_PSGlib_SetMusicVolumeAttenuation

EXTERN _PSGMusicStatus, _PSGChannel2SFX, _PSGChannel3SFX

EXTERN _PSGMusicVolumeAttenuation
EXTERN _PSGChan0Volume, _PSGChan1Volume, _PSGChan2Volume, _PSGChan3Volume

asm_PSGlib_SetMusicVolumeAttenuation:

   ; void PSGSetMusicVolumeAttenutation (void)
   ; sets the volume attenuation for the music (0-15)
   ;
	; enter : l = volume attenuation (0-15)
	;
   ; uses  : af

   ld a,l
	ld (_PSGMusicVolumeAttenuation),a
	
	ld a,(_PSGMusicStatus)
	or a
	ret z
	
   ld a,(_PSGChan0Volume)

   add a,l
   cp 16
   
   jr c, outchan0
   ld a,15
   
outchan0:

   or PSGLatch|PSGChannel0|PSGVolumeData
   out (PSGPort),a
	
	ld a,(_PSGChan1Volume)
   
   add a,l
   cp 16
   
   jr c, outchan1
   ld a,15

outchan1:

   or PSGLatch|PSGChannel1|PSGVolumeData
   out (PSGPort),a

	ld a,(_PSGChannel2SFX)
	or a
	jr nz, skipchan2

	ld a,(_PSGChan2Volume)
   
   add a,l
   cp 16
   
   jr c, outchan2
   ld a,15

outchan2:

   or PSGLatch|PSGChannel2|PSGVolumeData
   out (PSGPort),a
	
skipchan2:

   ld a,(_PSGChannel3SFX)
	or a
	ret nz
	
	ld a,(_PSGChan3Volume)
   
   add a,l
   cp 16
   
   jr c, outchan3
   ld a,15

outchan3:

   or PSGLatch|PSGChannel3|PSGVolumeData
   out (PSGPort),a
	
	ret
