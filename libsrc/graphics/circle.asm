;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: circle.asm,v 1.6 2016-04-13 21:09:09 dom Exp $
;


;Usage: circle(struct *pixels)


                SECTION         code_clib
                PUBLIC    circle
                PUBLIC    _circle

                EXTERN     draw_circle
                EXTERN     plotpixel
                EXTERN     swapgfxbk
		EXTERN    __graphics_end


.circle
._circle
		push	ix
		ld	ix,2
		add	ix,sp
		ld	e,(ix+2)	;skip
		ld	d,(ix+4)	;radius
		ld	c,(ix+6)	;y
		ld	b,(ix+8)	;x
                ld      ix,plotpixel
                call    swapgfxbk
                call    draw_circle
                jp      __graphics_end

