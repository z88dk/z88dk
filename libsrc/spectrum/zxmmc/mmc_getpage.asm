; 
;	ZX Spectrum ZXMMC specific routines 
;	ported to z88dk by Stefano Bodrato - Feb 2010
;	
;	$Id: mmc_getpage.asm,v 1.2 2015-01-19 01:33:11 pauloscustodio Exp $ 
;
;-----------------------------------------------------------------------------------------
; Get the current ZXMMC+ page setting
;-----------------------------------------------------------------------------------------
;

	PUBLIC	mmc_getpage
	
	INCLUDE "zxmmc.def"

mmc_getpage:
	in	a,(FASTPAGE)
	ld	h,0
	ld	l,a
	ret
