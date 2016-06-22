;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;       Wide resolution (WORD based parameters) version by Stefano Bodrato
;
;	$Id: w_xorplot.asm,v 1.4 2016-06-22 22:40:19 dom Exp $
;

;Usage: xorplot(int x, int y)

		SECTION   code_clib
                PUBLIC    xorplot
                PUBLIC    _xorplot
                EXTERN     swapgfxbk
                EXTERN    swapgfxbk1

                EXTERN     w_xorpixel

.xorplot
._xorplot
		pop	bc
		pop	de
		pop	hl
		push	hl
		push	de
		push	bc

                call    swapgfxbk
                call    w_xorpixel
                jp      swapgfxbk1

