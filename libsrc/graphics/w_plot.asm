;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;       Wide resolution (WORD based parameters) version by Stefano Bodrato
;
;	$Id: w_plot.asm,v 1.3 2016-04-13 21:09:09 dom Exp $
;

;Usage: plot(int x, int y)



        SECTION code_clib
                PUBLIC    plot
                PUBLIC    _plot
                EXTERN     swapgfxbk
                EXTERN    swapgfxbk1

                EXTERN     w_plotpixel

.plot
._plot
		pop	bc
		pop	de
		pop	hl
		push	hl
		push	de
		push	bc

                call    swapgfxbk
                call    w_plotpixel
                jp      swapgfxbk1

