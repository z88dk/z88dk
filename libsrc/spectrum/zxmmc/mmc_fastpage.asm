; 
;	ZX Spectrum ZXMMC specific routines 
;	code by Luca Bisti
;	ported to z88dk by Stefano Bodrato - Feb 2010
;	
;	$Id: mmc_fastpage.asm,v 1.3 2015-01-19 01:33:11 pauloscustodio Exp $ 
;
;-----------------------------------------------------------------------------------------
; Page in the requested ZXMMC bank
;-----------------------------------------------------------------------------------------
;

	PUBLIC	mmc_fastpage
	
	INCLUDE "zxmmc.def"

	
mmc_fastpage:
	di
	ld a,l
	out (FASTPAGE),a
	ret
