;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;



                INCLUDE "grafix.inc"    /* Contains fn defs */

                XLIB    undraw
                LIB     swapgfxbk
                XREF	swapgfxbk1

                LIB     line
                LIB     respixel



.undraw
		ld	ix,0
		add	ix,sp
		ld	e,(ix+2)	;y1
		ld	d,(ix+4)	;x1
		ld	l,(ix+6)	;y0
		ld	h,(ix+8)	;x0
                ld      ix,respixel
                call    swapgfxbk
                call    line
                jp      swapgfxbk1

