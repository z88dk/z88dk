;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;       Wide resolution (WORD based parameters) version by Stefano Bodrato
;
;	$Id: w_xorplot.asm,v 1.2 2011-04-01 06:50:45 stefano Exp $
;

;Usage: xorplot(int x, int y)


                XLIB    xorplot
                LIB     swapgfxbk
                XREF    swapgfxbk1

                LIB     w_xorpixel

.xorplot
		pop	bc
		pop	de
		pop	hl
		push	hl
		push	de
		push	bc

                call    swapgfxbk
                call    w_xorpixel
                jp      swapgfxbk1

