;
;       ZX81 Graphics Functions - Small C+ stubs
;
;	ZX 81 version By Stefano Bodrato
;	Moved the HL' thing under CRT0
;
;
;	$Id: swapgfxbk.asm,v 1.6 2002-04-22 14:45:50 stefano Exp $
;


                XLIB    swapgfxbk

		XDEF	swapgfxbk1
		
.swapgfxbk
		ret
.swapgfxbk1
		; This would become IX when swapped !
		;ld	iy,16384 
                ret
