;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: w_drawto.asm,v 1.4 2016-04-13 21:09:09 dom Exp $
;


;Usage: drawto(struct *pixels)


        SECTION code_clib
                PUBLIC    drawto
                PUBLIC    _drawto
                EXTERN     swapgfxbk
                EXTERN	__graphics_end

                EXTERN     w_line
                EXTERN     w_plotpixel


.drawto
._drawto
		push	ix
		ld	ix,4
		add	ix,sp
		ld	l,(ix+2)
		ld	h,(ix+3)
		ld	e,(ix+0)
		ld	d,(ix+1)
                call    swapgfxbk
                ld      ix,w_plotpixel
                call    w_line
                jp      __graphics_end

