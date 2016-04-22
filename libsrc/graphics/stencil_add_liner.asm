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
;	$Id: stencil_add_liner.asm,v 1.5 2016-04-22 20:29:51 dom Exp $
;

;; void stencil_add_liner(int dx, int dy, unsigned char *stencil)


		SECTION	  code_clib
                PUBLIC    stencil_add_liner
                PUBLIC    _stencil_add_liner

                EXTERN     Line_r
                EXTERN     stencil_add_pixel 

                EXTERN     swapgfxbk
                EXTERN    swapgfxbk1

                EXTERN    stencil_ptr
		EXTERN	  __graphics_end

.stencil_add_liner
._stencil_add_liner
		push	ix
		ld	ix,2
		add	ix,sp

		ld	l,(ix+2)	;pointer to stencil
		ld	h,(ix+3)
		ld	(stencil_ptr),hl

		ld	d,0
		ld	e,(ix+4)	;y0
		ld	h,d
		ld	l,(ix+6)	;x0

				call    swapgfxbk
		
                ld      ix,stencil_add_pixel
                call      Line_r
                
                jp     __graphics_end

