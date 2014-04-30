;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: drawto.asm,v 1.4 2014-04-30 18:34:18 stefano Exp $
;


;Usage: drawto(struct *pixels)


                XLIB    drawto
                LIB     swapgfxbk
                XREF	swapgfxbk1

				XREF	coords

                LIB     Line
                LIB     plotpixel



.drawto
		ld	ix,0
		add	ix,sp
		ld	hl,(coords)
		ld	e,(ix+2)	;y
		ld	d,(ix+4)	;x

                call    swapgfxbk
                ld      ix,plotpixel
                call    Line
                jp      swapgfxbk1

