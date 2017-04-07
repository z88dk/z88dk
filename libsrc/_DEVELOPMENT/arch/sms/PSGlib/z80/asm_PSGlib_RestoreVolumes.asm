; **************************************************
; PSGlib - C programming library for the SEGA PSG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "PSGlib_private.inc"

SECTION code_clib
SECTION code_PSGlib

PUBLIC asm_PSGlib_RestoreVolumes

EXTERN __PSGlib_MusicStatus, __PSGlib_Channel2SFX, __PSGlib_Channel3SFX

EXTERN __PSGlib_MusicVolumeAttenuation
EXTERN __PSGlib_Chan0Volume, __PSGlib_Chan1Volume, __PSGlib_Chan2Volume, __PSGlib_Chan3Volume

EXTERN __PSGlib_SFXChan2Volume, __PSGlib_SFXChan3Volume

asm_PSGlib_RestoreVolumes:

   ; void PSGRestoreVolumes (void)
   ; restore the PSG channels volumes (if a tune or an SFX uses them!)
   ;
   ; uses  : af, hl

   ld a,(__PSGlib_MusicStatus)
	
	ld hl,(__PSGlib_MusicVolumeAttenuation)
	ld h,a
	
	; h = __PSGlib_MusicStatus
	; l = __PSGlib_MusicVolumeAttenuation
	
	or a
	jr z, skipchan01

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

skipchan01:

   ld a,(__PSGlib_Channel2SFX)
   or a
	
	ld a,(__PSGlib_SFXChan2Volume)
	jr nz, outchan2
	
	inc h
	dec h
	jr z, skipchan2
	
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
   
   ld a,(__PSGlib_SFXChan3Volume)
   jr nz, outchan3
   
	inc h
	dec h
	ret z
	
   ld a,(__PSGlib_Chan3Volume)
   
   add a,l
   cp 16
   
   jr c, outchan3
   ld a,15

outchan3:

   or PSGLatch|PSGChannel3|PSGVolumeData
   out (PSGPort),a
   
   ret
