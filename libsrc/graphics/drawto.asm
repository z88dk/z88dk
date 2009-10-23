;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: drawto.asm,v 1.2 2009-10-23 14:25:50 stefano Exp $
;


;Usage: drawto(struct *pixels)


                XLIB    drawto
                LIB     swapgfxbk
                XREF	swapgfxbk1

				XREF	COORDS

                LIB     line
                LIB     plotpixel



.drawto
		ld	ix,0
		add	ix,sp
		ld	hl,(COORDS)
		ld	e,(ix+2)	;y
		ld	d,(ix+4)	;x

                call    swapgfxbk
                ld      ix,plotpixel
                call    line
                jp      swapgfxbk1

