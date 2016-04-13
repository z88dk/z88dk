;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: draw.asm,v 1.9 2016-04-13 20:16:59 dom Exp $
;


                PUBLIC    draw
		PUBLIC	  _draw
                EXTERN     swapgfxbk
		EXTERN        __graphics_end

                EXTERN     Line
                EXTERN     plotpixel


.draw
._draw
		push	ix
		ld	ix,2
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
		jp	__graphics_end

