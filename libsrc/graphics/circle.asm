;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;


;Usage: circle(struct *pixels)


                INCLUDE "grafix.inc"    /* Contains fn defs */

                XLIB    circle

                LIB     draw_circle
                LIB     plotpixel
                LIB     swapgfxbk
		XREF	swapgfxbk1


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

