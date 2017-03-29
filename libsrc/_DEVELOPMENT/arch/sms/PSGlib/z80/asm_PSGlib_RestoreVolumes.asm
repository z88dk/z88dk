; **************************************************
; PSGlib - C programming library for the SEGA PSG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "PSGlib_private.inc"

SECTION code_clib
SECTION code_PSGlib

PUBLIC asm_PSGlib_RestoreVolumes

EXTERN _PSGMusicStatus, _PSGChannel2SFX, _PSGChannel3SFX

EXTERN _PSGMusicVolumeAttenuation
EXTERN _PSGChan0Volume, _PSGChan1Volume, _PSGChan2Volume, _PSGChan3Volume

EXTERN _PSGSFXChan2Volume, _PSGSFXChan3Volume

asm_PSGlib_RestoreVolumes:

   ; void PSGRestoreVolumes (void)
   ; restore the PSG channels volumes (if a tune or an SFX uses them!)
   ;
   ; uses  : af, hl

   ld a,(_PSGMusicStatus)
	
	ld hl,(_PSGMusicVolumeAttenuation)
	ld h,a
	
	; h = _PSGMusicStatus
	; l = _PSGMusicVolumeAttenuation
	
	or a
	jr z, skipchan01

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

skipchan01:

   ld a,(_PSGChannel2SFX)
   or a
	
	ld a,(_PSGSFXChan2Volume)
	jr nz, outchan2
	
	inc h
	dec h
	jr z, skipchan2
	
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
   
   ld a,(_PSGSFXChan3Volume)
   jr nz, outchan3
   
	inc h
	dec h
	ret z
	
   ld a,(_PSGChan3Volume)
   
   add a,l
   cp 16
   
   jr c, outchan3
   ld a,15

outchan3:

   or PSGLatch|PSGChannel3|PSGVolumeData
   out (PSGPort),a
   
   ret
