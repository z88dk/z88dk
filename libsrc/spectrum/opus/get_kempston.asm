;
;	ZX Spectrum OPUS DISCOVERY specific routines
;
;	Stefano Bodrato - Jun. 2006
;
; 	This routine get the kempston joystick emulation status.
;
;	$Id: get_kempston.asm,v 1.1 2007-10-04 12:18:55 stefano Exp $
;

	XLIB	get_kempston
	
get_kempston:

	call	$1708		; page_in
	ld	a,($3000)
	and	128
	ld	hl,0
	and	a
	jr	z,pageout
	inc	hl
.pageout
	jp	$1748
