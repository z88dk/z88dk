;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, MAR 2010
;
;	void ula_normal_mode();
;
;	$Id: ula_normal_mode.asm,v 1.3 2016-06-10 21:14:23 dom Exp $
;

	SECTION code_clib
	PUBLIC	ula_normal_mode
	PUBLIC	_ula_normal_mode

ula_normal_mode:
_ula_normal_mode:
	; Enter in 64 colour mode
	ld	bc,$bf3b
	ld	a,64	; select mode group (01xxxxxx)
	out	(c),a
	ld	b,$ff
	ld	a,0		; normal mode
	out	(c),a
	ret
