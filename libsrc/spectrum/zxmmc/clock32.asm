; 
;	ZX Spectrum ZXMMC specific routines 
;	code by Alessandro Poppi
;	ported to z88dk by Stefano Bodrato - Feb 2010
;
;	$Id: clock32.asm,v 1.1 2010-03-12 15:21:14 stefano Exp $ 
;
;------------------------------------------------------------------------------------
; 32 clock cycles - internal use timing loop
;------------------------------------------------------------------------------------

	XLIB	clock32

	INCLUDE "zxmmc.def"
	
clock32:
	push bc
	ld b,4
l_4bytes:
	in a,(SPI_PORT)			; some more clock cycles
	djnz l_4bytes
	pop bc
	ret

