;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;       Wide resolution (WORD based parameters) version by Stefano Bodrato
;
;	$Id: w_draw.asm,v 1.3 2016-04-13 20:16:59 dom Exp $
;


                PUBLIC    draw
                PUBLIC    _draw
                EXTERN     swapgfxbk
                EXTERN	__graphics_end

                EXTERN     w_line
                EXTERN     w_plotpixel


.draw
._draw
		push	ix
		ld	ix,2
		add	ix,sp
		ld	l,(ix+6)
		ld	h,(ix+7)
		ld	e,(ix+4)
		ld	d,(ix+5)

		call    swapgfxbk
		call	w_plotpixel
                call    swapgfxbk1

		ld	l,(ix+2)
		ld	h,(ix+3)
		ld	e,(ix+0)
		ld	d,(ix+1)

		call    swapgfxbk
                ld      ix,w_plotpixel
                call    w_line
                jp      __graphics_end
