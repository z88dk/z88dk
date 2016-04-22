;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;	Compute the line coordinates and put into a vector
;	Basic concept by Rafael de Oliveira Jannone (calculate_side)
;
;       Stefano Bodrato - 13/3/2009
;
;
;	$Id: stencil_add_side.asm,v 1.7 2016-04-22 20:29:52 dom Exp $
;

;; void stencil_add_side(int x1, int y1, int x2, int y2, unsigned char *stencil)


		SECTION	  code_clib
                PUBLIC    stencil_add_side
                PUBLIC    _stencil_add_side

                EXTERN     Line
                EXTERN	stencil_add_pixel 
                EXTERN     swapgfxbk
                EXTERN    swapgfxbk1
		EXTERN	  __graphics_end
                EXTERN	stencil_ptr

.stencil_add_side
._stencil_add_side
		push	ix
		ld	ix,2
		add	ix,sp

		ld	l,(ix+2)	;pointer to stencil
		ld	h,(ix+3)
		ld	(stencil_ptr),hl

		ld	l,(ix+8)	;y0
		ld	h,(ix+10)	;x0
		ld	e,(ix+4)	;y1
		ld	d,(ix+6)	;x1

				call	swapgfxbk
                ld      ix,stencil_add_pixel
                call    Line
                jp      __graphics_end


