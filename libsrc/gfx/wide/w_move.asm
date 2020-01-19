;
;       Turtle graphics library
;       Stefano - 11/2017
;
;       $Id: w_move.asm $
;

IF !__CPU_INTEL__
        SECTION code_graphics
			PUBLIC    move
			PUBLIC    _move
			EXTERN     swapgfxbk
			EXTERN	__graphics_end

			EXTERN	__pen
			EXTERN     w_line_r
			EXTERN     w_plotpixel
			EXTERN     w_setxy


.move
._move
		push	ix
		ld	ix,2
		add	ix,sp
		ld	e,(ix+2)
		ld	d,(ix+3)
		ld	l,(ix+4)
		ld	h,(ix+5)
		
		call    swapgfxbk
				
		ld	a,(__pen)
		ld	ix,w_setxy
		rla
		jr	nc,pen_up
		ld	ix,w_plotpixel
.pen_up

		call    w_line_r
		jp      __graphics_end

ENDIF
