;
;	ZX Spectrum OPUS DISCOVERY specific routines
;
;	Stefano Bodrato - Jun. 2006
;
; 	This routine get the kempston joystick emulation status.
;
;	$Id: get_kempston.asm,v 1.3 2016-06-27 19:16:33 dom Exp $
;

	SECTION code_clib
	PUBLIC	get_kempston
	PUBLIC	_get_kempston
	
get_kempston:
_get_kempston:

	call	$1708		; page_in
	ld	a,($3000)
	and	128
	ld	hl,0
	and	a
	jr	z,pageout
	inc	hl
.pageout
	jp	$1748
