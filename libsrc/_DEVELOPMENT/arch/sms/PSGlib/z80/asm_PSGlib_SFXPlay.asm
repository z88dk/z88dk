; **************************************************
; PSGlib - C programming library for the SEGA PSG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "PSGlib_private.inc"

SECTION code_clib
SECTION code_PSGlib

PUBLIC asm_PSGlib_SFXPlay

EXTERN asm_PSGlib_SFXStop

EXTERN _PSGSFXLoopFlag, _PSGSFXSkipFrames, _PSGSFXSubstringLen
EXTERN _PSGSFXStart, _PSGSFXPointer, _PSGSFXLoopPoint
EXTERN _PSGSFXStatus, _PSGChannel2SFX, _PSGChannel3SFX

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
	ld (_PSGSFXLoopFlag),a
	ld (_PSGSFXSkipFrames),a
	ld (_PSGSFXSubstringLen),a
	
	ex de,hl
	ld (_PSGSFXStart),hl
	ld (_PSGSFXPointer),hl
	ld (_PSGSFXLoopPoint),hl
	
	ld a,c
	and SFX_CHANNEL2
	
	ld a,PSG_PLAYING
	jr nz, setchan2
	ld a,PSG_STOPPED

setchan2:

   ld (_PSGChannel2SFX),a

   ld a,c
   and SFX_CHANNEL3

   ld a,PSG_PLAYING
   jr nz, setchan3
   ld a,PSG_STOPPED

setchan3:

   ld (_PSGChannel3SFX),a

   ld a,PSG_PLAYING
   ld (_PSGSFXStatus),a

   ret
