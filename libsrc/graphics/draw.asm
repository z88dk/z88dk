;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: draw.asm,v 1.4 2001-08-17 15:01:41 stefano Exp $
;


                XLIB    draw
                LIB     swapgfxbk
                XREF	swapgfxbk1

                LIB     line
                LIB     plotpixel


.draw
		ld	ix,0
		add	ix,sp
		ld	l,(ix+6)	;y0
		ld	h,(ix+8)	;x0
		push	hl
		call	plotpixel
		pop	hl
		ld	e,(ix+2)	;y1
		ld	d,(ix+4)	;x1
                ld      ix,plotpixel
                call    swapgfxbk
                call    line
                jp      swapgfxbk1

