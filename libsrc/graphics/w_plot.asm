;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;       Wide resolution (WORD based parameters) version by Stefano Bodrato
;
;	$Id: w_plot.asm,v 1.1 2008-07-17 15:39:56 stefano Exp $
;

;Usage: plot(int x, int y)



                XLIB    plot
                LIB     swapgfxbk
                XREF    swapgfxbk1

                LIB     w_plotpixel

.plot
		pop	bc
		pop	de
		pop	hl
		push	hl
		push	de
		push	bc

                call    swapgfxbk
                call    w_plotpixel
                jp      swapgfxbk1

