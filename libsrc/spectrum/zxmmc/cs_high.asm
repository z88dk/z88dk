; 
;	ZX Spectrum ZXMMC specific routines 
;	code by Alessandro Poppi
;	ported to z88dk by Stefano Bodrato - Feb 2010
;
;	$Id: cs_high.asm,v 1.3 2016-06-10 21:28:03 dom Exp $ 
;
;------------------------------------------------------------------------------------
; CHIP_SELECT HIGH subroutine. Destroys no registers. Entire port is tied to '1'.
;------------------------------------------------------------------------------------
;

	SECTION	code_clib
	PUBLIC	cs_high

	INCLUDE "zxmmc.def"
	

cs_high:
	push af
	ld a,255
	out (OUT_PORT),a
	pop af
	ret
