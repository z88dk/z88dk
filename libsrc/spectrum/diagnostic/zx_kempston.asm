;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, 14/09/2006
;
;	int zx_kempston();
;
;	The result is:
;	- 1 (true) if the Kempston Joystick is connected
;	- 0 (false) otherwise
;
;	$Id: zx_kempston.asm,v 1.2 2015-01-19 01:33:08 pauloscustodio Exp $
;

	PUBLIC	zx_kempston
	
zx_kempston:
	ld	hl,0
	in	a,(31)
	cp	32
	ret	nc
	inc	hl
	ret
