;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: drawr.asm,v 1.3 2001-04-18 13:21:37 stefano Exp $
;


;Usage: drawr(struct *pixels)


                XLIB    drawr
                LIB     swapgfxbk
                XREF	swapgfxbk1

                LIB     line_r
                LIB     plotpixel



.drawr
		ld	ix,0
		add	ix,sp
		ld	e,(ix+2)	;py
		ld	d,(ix+3)
		ld	l,(ix+4)	;px
		ld	h,(ix+5)
                ld      ix,plotpixel
                call    swapgfxbk
                call    line_r
                jp      swapgfxbk1

