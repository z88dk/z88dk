;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, 14/09/2006
;
;	int zx_printer();
;
;	The result is:
;	- 1 (true) if the ZX printer is connected
;	- 0 (false) otherwise
;
;	$Id: zx_printer.asm,v 1.1 2006-12-01 16:58:30 stefano Exp $
;

	XLIB	zx_printer
	
zx_printer:
	ld	hl,0
	in	a,($fb)
	bit	6,a
	ret	nz
	inc	hl
	ret
