;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: drawto.asm,v 1.3 2014-04-18 09:30:31 stefano Exp $
;


;Usage: drawto(struct *pixels)


                XLIB    drawto
                LIB     swapgfxbk
                XREF	swapgfxbk1

				XREF	coords

                LIB     line
                LIB     plotpixel



.drawto
		ld	ix,0
		add	ix,sp
		ld	hl,(coords)
		ld	e,(ix+2)	;y
		ld	d,(ix+4)	;x

                call    swapgfxbk
                ld      ix,plotpixel
                call    line
                jp      swapgfxbk1

