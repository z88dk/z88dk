;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;


;Usage: undrawr(struct *pixels)


                INCLUDE "grafix.inc"    /* Contains fn defs */

                XLIB    undrawr
                LIB     swapgfxbk
                XREF	swapgfxbk1


                LIB     line_r
                LIB     respixel



.undrawr
		ld	ix,0
		add	ix,sp
		ld	e,(ix+2)
		ld	d,(ix+3)
		ld	l,(ix+4)
		ld	h,(ix+5)
                ld      ix,respixel
                call    swapgfxbk
                call    line_r
                jp      swapgfxbk1

