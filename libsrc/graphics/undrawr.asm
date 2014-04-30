;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: undrawr.asm,v 1.4 2014-04-30 18:34:18 stefano Exp $
;


;Usage: undrawr(struct *pixels)



                XLIB    undrawr
                LIB     swapgfxbk
                XREF	swapgfxbk1


                LIB     Line_r
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
                call    Line_r
                jp      swapgfxbk1

