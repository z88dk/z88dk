; 
;	ZX Spectrum ZXMMC specific routines 
;	code by Alessandro Poppi
;	ported to z88dk by Stefano Bodrato - Feb 2010
;
;	$Id: clock32.asm,v 1.3 2016-06-10 21:28:03 dom Exp $ 
;
;------------------------------------------------------------------------------------
; 32 clock cycles - internal use timing loop
;------------------------------------------------------------------------------------

	SECTION	code_clib
	PUBLIC	clock32

	INCLUDE "zxmmc.def"
	
clock32:
	push bc
	ld b,4
l_4bytes:
	in a,(SPI_PORT)			; some more clock cycles
	djnz l_4bytes
	pop bc
	ret

