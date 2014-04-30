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
;	$Id: stencil_add_lineto.asm,v 1.5 2014-04-30 18:34:18 stefano Exp $
;

;; void stencil_add_lineto(int x, int y, unsigned char *stencil)



                XLIB    stencil_add_lineto

                LIB     Line
                LIB     stencil_add_pixel 

				XREF	coords

                LIB     swapgfxbk
                XREF    swapgfxbk1

                XREF    stencil_ptr

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

