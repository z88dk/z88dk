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
;	$Id: stencil_add_side.asm,v 1.1 2009-04-15 21:00:58 stefano Exp $
;

;; void stencil_add_side(int x1, int y1, int x2, int y2, unsigned char *stencil)



                XLIB    stencil_add_side

                LIB     line
                LIB	stencil_add_pixel 

                ;LIB     swapgfxbk
                ;XREF    swapgfxbk1

                XREF	stencil_ptr

.stencil_add_side
		ld	ix,0
		add	ix,sp

		ld	l,(ix+2)	;pointer to stencil
		ld	h,(ix+3)
		ld	(stencil_ptr),hl

		;ld	l,(ix+4)	;pointer to leftmost vector
		;ld	h,(ix+5)
		;ld	(gfx_area),hl

		ld	l,(ix+8)	;y0
		ld	h,(ix+10)	;x0
		ld	e,(ix+4)	;y1
		ld	d,(ix+6)	;x1

		;call    swapgfxbk
		
		;push	hl
		;push    de
		;call	stencil_add_pixel
		;pop     de
		;pop	hl
		
                ld      ix,stencil_add_pixel
                call    line
                ret
                
                ;jp      swapgfxbk1

