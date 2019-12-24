;
;	Sharp X1 specific routines
;
;	void set_crtc_reg(int reg, int value);
;
;	Write data to a CRTC register
;
;	$Id: set_crtc_reg.asm,v 1.3 2016-06-10 23:45:21 dom Exp $
;

	SECTION	code_clib
	PUBLIC	set_crtc_reg
	PUBLIC	_set_crtc_reg
	

set_crtc_reg:
_set_crtc_reg:
	pop	hl
	pop	de
	pop	bc
	push	bc	; register
	push	de	; value
	push	hl	; RET address
	ld		a,c
	ld		bc,$1800
	out		(c),a
	inc		bc
	out		(c),e

	ret

