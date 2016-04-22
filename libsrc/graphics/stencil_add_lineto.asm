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
;	$Id: stencil_add_lineto.asm,v 1.7 2016-04-22 20:29:51 dom Exp $
;

;; void stencil_add_lineto(int x, int y, unsigned char *stencil)


		SECTION   code_clib
                PUBLIC    stencil_add_lineto
                PUBLIC    _stencil_add_lineto

                EXTERN     Line
                EXTERN     stencil_add_pixel 

				EXTERN	coords

                EXTERN     swapgfxbk
                EXTERN    swapgfxbk1

                EXTERN    stencil_ptr
		EXTERN	  __graphics_end

.stencil_add_lineto
._stencil_add_lineto
		push	ix
		ld	ix,2
		add	ix,sp

		ld	l,(ix+2)	;pointer to stencil
		ld	h,(ix+3)
		ld	(stencil_ptr),hl

		ld	hl,(coords)
		ld	e,(ix+4)	;y1
		ld	d,(ix+6)	;x1

		call    swapgfxbk
		
                ld      ix,stencil_add_pixel
                call      Line
                
                jp      __graphics_end

