;
;       ZX81 Graphics Functions - Small C+ stubs
;
;	ZX 81 version By Stefano Bodrato
;	Moved the HL' thing under CRT0
;
;
;	$Id: swapgfxbk.asm,v 1.4 2001-04-18 13:21:38 stefano Exp $
;


                XLIB    swapgfxbk

		XDEF	swapgfxbk1


.swapgfxbk
		ret
.swapgfxbk1
		ld	iy,16384
                ret
