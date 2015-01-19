;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: drawto.asm,v 1.5 2015-01-19 01:32:46 pauloscustodio Exp $
;


;Usage: drawto(struct *pixels)


                PUBLIC    drawto
                EXTERN     swapgfxbk
                EXTERN	swapgfxbk1

				EXTERN	coords

                EXTERN     Line
                EXTERN     plotpixel



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

