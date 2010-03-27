; 
;	ZX Spectrum ZXMMC specific routines 
;	ported to z88dk by Stefano Bodrato - Feb 2010
;	
;	$Id: mmc_getpage.asm,v 1.1 2010-03-27 18:59:25 stefano Exp $ 
;
;-----------------------------------------------------------------------------------------
; Get the current ZXMMC+ page setting
;-----------------------------------------------------------------------------------------
;

	XLIB	mmc_getpage
	
	INCLUDE "zxmmc.def"

mmc_getpage:
	in	a,(FASTPAGE)
	ld	h,0
	ld	l,a
	ret
