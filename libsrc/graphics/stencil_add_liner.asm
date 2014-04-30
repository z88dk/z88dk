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
;	$Id: stencil_add_liner.asm,v 1.3 2014-04-30 18:34:18 stefano Exp $
;

;; void stencil_add_liner(int dx, int dy, unsigned char *stencil)



                XLIB    stencil_add_liner

                LIB     Line_r
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

		ld	d,0
		ld	e,(ix+4)	;y0
		ld	h,d
		ld	l,(ix+6)	;x0

				call    swapgfxbk
		
                ld      ix,stencil_add_pixel
                call      Line_r
                
                jp      swapgfxbk1

