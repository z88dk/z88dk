; 
;	ZX Spectrum ZXMMC specific routines 
;	code by Alessandro Poppi
;	ported to z88dk by Stefano Bodrato - Feb 2010
;
;	$Id: cs_high.asm,v 1.1 2010-03-12 15:21:14 stefano Exp $ 
;
;------------------------------------------------------------------------------------
; CHIP_SELECT HIGH subroutine. Destroys no registers. Entire port is tied to '1'.
;------------------------------------------------------------------------------------
;

	XLIB	cs_high

	INCLUDE "zxmmc.def"
	

cs_high:
	push af
	ld a,255
	out (OUT_PORT),a
	pop af
	ret
