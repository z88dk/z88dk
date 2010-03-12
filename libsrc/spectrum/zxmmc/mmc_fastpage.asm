; 
;	ZX Spectrum ZXMMC specific routines 
;	code by Luca Bisti
;	ported to z88dk by Stefano Bodrato - Feb 2010
;	
;	$Id: mmc_fastpage.asm,v 1.1 2010-03-12 15:21:14 stefano Exp $ 
;
;-----------------------------------------------------------------------------------------
; Page in the requested ZXMMC bank
;-----------------------------------------------------------------------------------------
;

	XLIB	mmc_fastpage
	
	INCLUDE "zxmmc.def"

	
mmc_fastpage:
	ld a,l
	out (FASTPAGE),a
	ret
