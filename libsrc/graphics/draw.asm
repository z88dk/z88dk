;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: draw.asm,v 1.8 2015-01-19 01:32:46 pauloscustodio Exp $
;


                PUBLIC    draw
                EXTERN     swapgfxbk
                EXTERN    swapgfxbk1

                EXTERN     Line
                EXTERN     plotpixel


.draw
		ld	ix,0
		add	ix,sp
		ld	l,(ix+6)	;y0
		ld	h,(ix+8)	;x0
		ld	e,(ix+2)	;y1
		ld	d,(ix+4)	;x1
		call    swapgfxbk
		push	hl
		push    de
		call	plotpixel
		pop     de
		pop	hl
                ld      ix,plotpixel
                call    Line
                jp      swapgfxbk1
