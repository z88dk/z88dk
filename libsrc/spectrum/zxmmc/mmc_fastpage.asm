; 
;	ZX Spectrum ZXMMC specific routines 
;	code by Luca Bisti
;	ported to z88dk by Stefano Bodrato - Feb 2010
;	
;	$Id: mmc_fastpage.asm,v 1.4 2016-06-10 21:28:03 dom Exp $ 
;
;-----------------------------------------------------------------------------------------
; Page in the requested ZXMMC bank
;-----------------------------------------------------------------------------------------
;

	SECTION	code_clib
	PUBLIC	mmc_fastpage
	PUBLIC	_mmc_fastpage
	
	INCLUDE "zxmmc.def"

	
mmc_fastpage:
_mmc_fastpage:
	di
	ld a,l
	out (FASTPAGE),a
	ret
