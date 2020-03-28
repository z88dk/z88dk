;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, 14/09/2006
;
;	int zx_iss_stick();
;
;	The result is:
;	- 1 (true) if the ISS Joystick interface is connected
;	- 0 (false) otherwise
;
;	$Id: zx_iss_stick.asm,v 1.3 2016-06-10 20:02:05 dom Exp $
;

	SECTION code_clib
	PUBLIC	zx_iss_stick
	PUBLIC	_zx_iss_stick
	
zx_iss_stick:
_zx_iss_stick:
	ld	hl,0
	in	a,(32)
	cp	32
	ret	nc
	inc	hl
	ret
