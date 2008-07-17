;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;       Wide resolution (WORD based parameters) version by Stefano Bodrato
;
;	$Id: w_xorplot.asm,v 1.1 2008-07-17 15:39:56 stefano Exp $
;

;Usage: xorplot(int x, int y)


                XLIB    xorplot
                LIB     swapgfxbk
                XREF    swapgfxbk1

                LIB     xorpixel

.xorplot
		pop	bc
		pop	de
		pop	hl
		push	hl
		push	de
		push	bc

                call    swapgfxbk
                call    xorpixel
                jp      swapgfxbk1

