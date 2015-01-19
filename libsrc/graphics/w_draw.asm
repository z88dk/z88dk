;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;       Wide resolution (WORD based parameters) version by Stefano Bodrato
;
;	$Id: w_draw.asm,v 1.2 2015-01-19 01:32:46 pauloscustodio Exp $
;


                PUBLIC    draw
                EXTERN     swapgfxbk
                EXTERN    swapgfxbk1

                EXTERN     w_line
                EXTERN     w_plotpixel


.draw
		ld	ix,2
		add	ix,sp
		ld	l,(ix+6)
		ld	h,(ix+7)
		ld	e,(ix+4)
		ld	d,(ix+5)

		call    swapgfxbk
		call	w_plotpixel
                call    swapgfxbk1

		ld	l,(ix+2)
		ld	h,(ix+3)
		ld	e,(ix+0)
		ld	d,(ix+1)

		call    swapgfxbk
                ld      ix,w_plotpixel
                call    w_line
                jp      swapgfxbk1
