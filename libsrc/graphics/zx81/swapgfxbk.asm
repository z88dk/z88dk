;
;       ZX81 Graphics Functions - Small C+ stubs
;
;	ZX 81 version By Stefano Bodrato
;	Moved the HL' thing under CRT0
;
;
;	$Id: swapgfxbk.asm,v 1.5 2002-04-17 21:30:25 dom Exp $
;


                XLIB    swapgfxbk

		XDEF	swapgfxbk1


.swapgfxbk
		ret
.swapgfxbk1
		ld	iy,16384
                ret
