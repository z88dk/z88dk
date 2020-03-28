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
;	$Id: zx_kempston.asm,v 1.3 2016-06-10 20:02:05 dom Exp $
;

	SECTION code_clib
	PUBLIC	zx_kempston
	PUBLIC	_zx_kempston
	
zx_kempston:
_zx_kempston:
	ld	hl,0
	in	a,(31)
	cp	32
	ret	nc
	inc	hl
	ret
