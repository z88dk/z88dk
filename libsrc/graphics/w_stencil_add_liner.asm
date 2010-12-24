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
;	$Id: w_stencil_add_liner.asm,v 1.1 2010-12-24 11:59:35 stefano Exp $
;

;; void stencil_add_liner(int dx, int dy, unsigned char *stencil)



                XLIB    stencil_add_liner

                LIB     line_r
                LIB     stencil_add_pixel 

                LIB     swapgfxbk
                XREF    swapgfxbk1

                XREF    stencil_ptr

.stencil_add_liner
		ld	ix,0
		add	ix,sp

		ld	l,(ix+2)	;pointer to stencil
		ld	h,(ix+3)
		ld	(stencil_ptr),hl

		ld	d,(ix+5)
		ld	e,(ix+4)	;y0
		ld	h,(ix+7)
		ld	l,(ix+6)	;x0

				call    swapgfxbk
		
                ld      ix,stencil_add_pixel
                call      line_r
                
                jp      swapgfxbk1

