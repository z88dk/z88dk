;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: circle.asm,v 1.4 2015-01-19 01:32:46 pauloscustodio Exp $
;


;Usage: circle(struct *pixels)


                PUBLIC    circle

                EXTERN     draw_circle
                EXTERN     plotpixel
                EXTERN     swapgfxbk
		EXTERN	swapgfxbk1


.circle
		ld	ix,0
		add	ix,sp
		ld	e,(ix+2)	;skip
		ld	d,(ix+4)	;radius
		ld	c,(ix+6)	;y
		ld	b,(ix+8)	;x
                ld      ix,plotpixel
                call    swapgfxbk
                call    draw_circle
                jp      swapgfxbk1

