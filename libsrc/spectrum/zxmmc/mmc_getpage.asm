; 
;	ZX Spectrum ZXMMC specific routines 
;	ported to z88dk by Stefano Bodrato - Feb 2010
;	
;	$Id: mmc_getpage.asm,v 1.3 2016-06-10 21:28:03 dom Exp $ 
;
;-----------------------------------------------------------------------------------------
; Get the current ZXMMC+ page setting
;-----------------------------------------------------------------------------------------
;

	SECTION	code_clib
	PUBLIC	mmc_getpage
	PUBLIC	_mmc_getpage
	
	INCLUDE "zxmmc.def"

mmc_getpage:
_mmc_getpage:
	in	a,(FASTPAGE)
	ld	h,0
	ld	l,a
	ret
