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
;	$Id: w_stencil_add_side.asm,v 1.3 2016-04-23 20:37:40 dom Exp $
;

;; void stencil_add_side(int x1, int y1, int x2, int y2, unsigned char *stencil)


		SECTION   code_clib
                PUBLIC    stencil_add_side
                PUBLIC    _stencil_add_side

                EXTERN     w_line
                EXTERN     stencil_add_pixel 
                EXTERN     swapgfxbk
                EXTERN    swapgfxbk1
                EXTERN	stencil_ptr
		EXTERN	__graphics_end

.stencil_add_side
._stencil_add_side
		push	ix
		ld	ix,2
		add	ix,sp

		ld	l,(ix+2)	;pointer to stencil
		ld	h,(ix+3)
		ld	(stencil_ptr),hl

		ld	l,(ix+10)
		ld	h,(ix+11)
		ld	e,(ix+8)
		ld	d,(ix+9)

		call    swapgfxbk
		call	stencil_add_pixel

		ld	l,(ix+6)
		ld	h,(ix+7)
		ld	e,(ix+4)
		ld	d,(ix+5)

                ld      ix,stencil_add_pixel
                call    w_line
                jp      __graphics_end

