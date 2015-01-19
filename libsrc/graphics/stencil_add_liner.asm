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
;	$Id: stencil_add_liner.asm,v 1.4 2015-01-19 01:32:46 pauloscustodio Exp $
;

;; void stencil_add_liner(int dx, int dy, unsigned char *stencil)



                PUBLIC    stencil_add_liner

                EXTERN     Line_r
                EXTERN     stencil_add_pixel 

                EXTERN     swapgfxbk
                EXTERN    swapgfxbk1

                EXTERN    stencil_ptr

.stencil_add_liner
		ld	ix,0
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
                
                jp      swapgfxbk1

