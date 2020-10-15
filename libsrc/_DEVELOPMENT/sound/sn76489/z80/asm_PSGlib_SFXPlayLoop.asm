; PSGlib - C programming library for the SEGA PSG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "PSGlib_private.inc"

SECTION code_clib
SECTION code_PSGlib

PUBLIC asm_PSGlib_SFXPlayLoop

EXTERN asm_PSGlib_SFXPlay, __PSGlib_SFXLoopFlag

asm_PSGlib_SFXPlayLoop:

   ; void PSGSFXPlayLoop (void *sfx, unsigned char channels)
	;   receives the address of the SFX to start continuously and the mask
	;   that indicates which channel(s) the SFX will use
	;
	; enter : de = void *sfx
	;          c = unsigned char channels
	;
	; uses  : af, de, hl
	
	call asm_PSGlib_SFXPlay
	
	ld a,1
	ld (__PSGlib_SFXLoopFlag),a
	
	ret
