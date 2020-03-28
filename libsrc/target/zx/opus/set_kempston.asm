;
;	ZX Spectrum OPUS DISCOVERY specific routines
;
; 	This routine sets the kempston joystick emulation mode.
;
;	$Id: set_kempston.asm,v 1.3 2016-06-27 19:16:34 dom Exp $
;

		SECTION code_clib
		PUBLIC	set_kempston
		PUBLIC	_set_kempston
	
set_kempston:
_set_kempston:

		pop	hl
		pop	bc
		ld	a,c
		push	bc
		push	hl
		call	$1708		; page_in
		ld	hl,$3000
		set	7,(hl)
		and	a
		jr	z,pageout
		res	7,(hl)
.pageout
		jp	$1748
