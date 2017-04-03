; **************************************************
; PSGlib - C programming library for the SEGA PSG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "PSGlib_private.inc"

SECTION code_clib
SECTION code_PSGlib

PUBLIC asm_PSGlib_SFXPlay

EXTERN asm_PSGlib_SFXStop

EXTERN __PSGlib_SFXLoopFlag, __PSGlib_SFXSkipFrames, __PSGlib_SFXSubstringLen
EXTERN __PSGlib_SFXStart, __PSGlib_SFXPointer, __PSGlib_SFXLoopPoint
EXTERN __PSGlib_SFXStatus, __PSGlib_Channel2SFX, __PSGlib_Channel3SFX

asm_PSGlib_SFXPlay:

   ; void PSGSFXPlay (void *sfx, unsigned char channels)
	;   receives the address of the SFX to start and the mask that indicates
   ;   which channel(s) the SFX will use
	;
	; enter : de = void *sfx
	;          c = unsigned char channels
	;
	; uses  : af, de, hl
	
	call asm_PSGlib_SFXStop
	
	xor a
	ld (__PSGlib_SFXLoopFlag),a
	ld (__PSGlib_SFXSkipFrames),a
	ld (__PSGlib_SFXSubstringLen),a
	
	ex de,hl
	ld (__PSGlib_SFXStart),hl
	ld (__PSGlib_SFXPointer),hl
	ld (__PSGlib_SFXLoopPoint),hl
	
	ld a,c
	and SFX_CHANNEL2
	
	ld a,PSG_PLAYING
	jr nz, setchan2
	ld a,PSG_STOPPED

setchan2:

   ld (__PSGlib_Channel2SFX),a

   ld a,c
   and SFX_CHANNEL3

   ld a,PSG_PLAYING
   jr nz, setchan3
   ld a,PSG_STOPPED

setchan3:

   ld (__PSGlib_Channel3SFX),a

   ld a,PSG_PLAYING
   ld (__PSGlib_SFXStatus),a

   ret
