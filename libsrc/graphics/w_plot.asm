;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;       Wide resolution (WORD based parameters) version by Stefano Bodrato
;
;	$Id: w_plot.asm,v 1.2 2015-01-19 01:32:46 pauloscustodio Exp $
;

;Usage: plot(int x, int y)



                PUBLIC    plot
                EXTERN     swapgfxbk
                EXTERN    swapgfxbk1

                EXTERN     w_plotpixel

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

