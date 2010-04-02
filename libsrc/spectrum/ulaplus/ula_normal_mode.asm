;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, MAR 2010
;
;	void ula_normal_mode();
;
;	$Id: ula_normal_mode.asm,v 1.1 2010-04-02 09:05:06 stefano Exp $
;

	XLIB	ula_normal_mode

ula_normal_mode:
	; Enter in 64 colour mode
	ld	bc,$bf3b
	ld	a,64	; select mode group (01xxxxxx)
	out	(c),a
	ld	b,$ff
	ld	a,0		; normal mode
	out	(c),a
	ret
