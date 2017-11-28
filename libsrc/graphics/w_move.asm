;
;       Turtle graphics library
;       Stefano - 11/2017
;
;       $Id: w_move.asm $
;

        SECTION code_clib
                PUBLIC    move
                PUBLIC    _move
                EXTERN     swapgfxbk
                EXTERN	__graphics_end

                EXTERN     w_line_r
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
                ld      ix,w_setxy
                call    w_line_r
                jp      __graphics_end

