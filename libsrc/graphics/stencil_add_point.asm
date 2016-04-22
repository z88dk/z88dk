;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;	Put a pixel in the stencil vectors
;
;       Stefano Bodrato - 08/10/2009
;
;
;	$Id: stencil_add_point.asm,v 1.5 2016-04-22 20:29:51 dom Exp $
;

;; void stencil_add_point(int x, int y, unsigned char *stencil)


		SECTION   code_clib
                PUBLIC    stencil_add_point
                PUBLIC    _stencil_add_point

                EXTERN     line
                EXTERN     stencil_add_pixel

                ;EXTERN     swapgfxbk
                ;EXTERN    swapgfxbk1

                EXTERN    stencil_ptr

.stencil_add_point
._stencil_add_point
		push	ix
		ld	ix,2
		add	ix,sp

		ld	l,(ix+2)	;pointer to stencil
		ld	h,(ix+3)
		ld	(stencil_ptr),hl

		;ld	l,(ix+4)	;pointer to leftmost vector
		;ld	h,(ix+5)
		;ld	(gfx_area),hl

		ld	l,(ix+4)	;y0
		ld	h,(ix+6)	;x0

		pop	ix	
		jp	stencil_add_pixel
		

