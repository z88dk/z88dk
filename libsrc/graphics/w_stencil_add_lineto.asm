;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;	Trace a relative line in the stencil vectors
;
;       Stefano Bodrato - 08/10/2009
;
;
;	$Id: w_stencil_add_lineto.asm,v 1.4 2016-04-23 20:37:40 dom Exp $
;

;; void stencil_add_lineto(int x, int y, unsigned char *stencil)


		SECTION   code_clib
                PUBLIC    stencil_add_lineto
                PUBLIC    _stencil_add_lineto

                EXTERN     w_line
                EXTERN     stencil_add_pixel 

                EXTERN     swapgfxbk
                EXTERN    swapgfxbk1

                EXTERN    stencil_ptr
		EXTERN    __graphics_end

.stencil_add_lineto
._stencil_add_lineto
		push	ix
		ld	ix,2
		add	ix,sp

		ld	l,(ix+2)	;pointer to stencil
		ld	h,(ix+3)
		ld	(stencil_ptr),hl

		ld	l,(ix+6)	;y1
		ld	h,(ix+7)
		ld	e,(ix+4)	;x1
		ld	d,(ix+5)

		call    swapgfxbk
		
                ld      ix,stencil_add_pixel
                call      w_line
                
                jp      __graphics_end

