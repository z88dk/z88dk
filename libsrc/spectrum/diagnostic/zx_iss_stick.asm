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
;	$Id: zx_iss_stick.asm,v 1.1 2008-06-29 08:25:47 aralbrec Exp $
;

	XLIB	zx_iss_stick
	
zx_iss_stick:
	ld	hl,0
	in	a,(32)
	cp	32
	ret	nc
	inc	hl
	ret
