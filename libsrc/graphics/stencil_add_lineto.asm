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
;	$Id: stencil_add_lineto.asm,v 1.6 2015-01-19 01:32:46 pauloscustodio Exp $
;

;; void stencil_add_lineto(int x, int y, unsigned char *stencil)



                PUBLIC    stencil_add_lineto

                EXTERN     Line
                EXTERN     stencil_add_pixel 

				EXTERN	coords

                EXTERN     swapgfxbk
                EXTERN    swapgfxbk1

                EXTERN    stencil_ptr

.stencil_add_lineto
		ld	ix,0
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
                
                jp      swapgfxbk1

