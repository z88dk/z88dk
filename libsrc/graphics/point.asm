;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;


;Usage: point(struct *pixel)
;Result is true/false


                INCLUDE "grafix.inc"    /* Contains fn defs */

                XLIB    point

                LIB     pointxy
                LIB     swapgfxbk



.point
		ld	ix,0
		add	ix,sp
		ld	l,(ix+2)
		ld	h,(ix+4)
                call    swapgfxbk
                call    pointxy
                ex      af,af'
                call    swapgfxbk
                ex      af,af'
                ld      hl,1
                ret     z       ;pixel set
                dec     hl
                ret

