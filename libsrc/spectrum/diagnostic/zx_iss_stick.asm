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
;	$Id: zx_iss_stick.asm,v 1.2 2015-01-19 01:33:08 pauloscustodio Exp $
;

	PUBLIC	zx_iss_stick
	
zx_iss_stick:
	ld	hl,0
	in	a,(32)
	cp	32
	ret	nc
	inc	hl
	ret
