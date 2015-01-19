;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;       Wide resolution (WORD based parameters) version by Stefano Bodrato
;
;	$Id: w_xorplot.asm,v 1.3 2015-01-19 01:32:47 pauloscustodio Exp $
;

;Usage: xorplot(int x, int y)


                PUBLIC    xorplot
                EXTERN     swapgfxbk
                EXTERN    swapgfxbk1

                EXTERN     w_xorpixel

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

