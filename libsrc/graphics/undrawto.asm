;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: undrawto.asm,v 1.3 2014-04-18 09:30:31 stefano Exp $
;


;Usage: undrawto(struct *pixels)


                XLIB    undrawto
                LIB     swapgfxbk
                XREF	swapgfxbk1

				XREF	coords

                LIB     line
                LIB     respixel



.undrawto
		ld	ix,0
		add	ix,sp
		ld	hl,(coords)
		ld	e,(ix+2)	;y
		ld	d,(ix+4)	;x

                call    swapgfxbk
                ld      ix,respixel
                call    line
                jp      swapgfxbk1

