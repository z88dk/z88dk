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
;	$Id: stencil_add_lineto.asm,v 1.2 2009-10-23 14:25:51 stefano Exp $
;

;; void stencil_add_lineto(int x, int y, unsigned char *stencil)



                XLIB    stencil_add_lineto

                LIB     line
                LIB     stencil_add_pixel 

				XREF	COORDS

                ;LIB     swapgfxbk
                ;XREF    swapgfxbk1

                XREF    stencil_ptr

.stencil_add_lineto
		ld	ix,0
		add	ix,sp

		ld	l,(ix+2)	;pointer to stencil
		ld	h,(ix+3)
		ld	(stencil_ptr),hl

		ld	hl,(COORDS)
		ld	e,(ix+4)	;y1
		ld	d,(ix+6)	;x1

		; call    swapgfxbk
		
                ld      ix,stencil_add_pixel
                jp      line
                
                ;jp      swapgfxbk1

