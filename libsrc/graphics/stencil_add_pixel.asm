;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;	Compute the line coordinates and put into a vector
;	Basic concept by Rafael de Oliveira Jannone (calculate_side)
;
;	Internal function to update the area object's vectors
;
;       Stefano Bodrato - 13/3/2009
;
;
;	$Id: stencil_add_pixel.asm,v 1.6 2016-07-02 09:01:35 dom Exp $
;

; registers changed after return:
;  ..bc..../ixiy same
;  af..dehl/.... different


	INCLUDE	"graphics/grafix.inc"
		SECTION	  code_clib
                PUBLIC    stencil_add_pixel
                PUBLIC    _stencil_add_pixel
                PUBLIC	stencil_ptr
                EXTERN	__gfx_coords


.stencil_add_pixel
._stencil_add_pixel
		ld	(__gfx_coords),hl	; update plot coordinates
		ld	d,0
		ld	e,l
		ld	a,h		; current X coordinate
		ld	hl,(stencil_ptr) ; right side vector
		add	hl,de
		
		cp	(hl)
		jr	nc,lo_higher
		ld	(hl),a
.lo_higher
		ld	de,maxy
		add	hl,de

		cp	(hl)
		ret	c	; hi_lower
		ld	(hl),a
		ret

		SECTION   bss_clib
.stencil_ptr	defw	0
