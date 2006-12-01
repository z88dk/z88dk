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
;	$Id: zx_kempston.asm,v 1.1 2006-12-01 16:58:30 stefano Exp $
;

	XLIB	zx_kempston
	
zx_kempston:
	ld	hl,0
	in	a,(31)
	cp	32
	ret	nc
	inc	hl
	ret
