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
;	$Id: zx_printer.asm,v 1.3 2016-06-10 20:02:05 dom Exp $
;

	SECTION code_clib
	PUBLIC	zx_printer
	PUBLIC	_zx_printer
	
zx_printer:
_zx_printer:
	ld	hl,0
	in	a,($fb)
	bit	6,a
	ret	nz
	inc	hl
	ret
