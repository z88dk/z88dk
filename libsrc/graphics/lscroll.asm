;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;


;Usage: lscroll(struct *pixels)


                INCLUDE "grafix.inc"    /* Contains fn defs */

                XLIB    lscroll

                LIB     scroll_left



.lscroll
		ld	ix,0
		add	ix,sp
		ld	a,(ix+2)
		ld	c,(ix+4)
		ld	b,(ix+6)
		ld	l,(ix+8)
		ld	h,(ix+10)
                jp      scroll_left

