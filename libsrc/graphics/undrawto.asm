;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: undrawto.asm,v 1.1 2009-10-13 11:41:43 stefano Exp $
;


;Usage: undrawto(struct *pixels)


                XLIB    undrawto
                LIB     swapgfxbk
                XREF	swapgfxbk1

				XREF	COORDS

                LIB     line
                LIB     respixel



.undrawto
		ld	ix,0
		add	ix,sp
		ld	hl,(COORDS)
		ld	e,(ix+2)	;y
		ld	d,(ix+4)	;x

                call    swapgfxbk
                ld      ix,respixel
                call    line
                jp      swapgfxbk1

