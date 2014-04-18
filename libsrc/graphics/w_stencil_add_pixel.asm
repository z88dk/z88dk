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
;	$Id: w_stencil_add_pixel.asm,v 1.2 2014-04-18 09:30:31 stefano Exp $
;

; registers changed after return:
;  ..bc..../ixiy same
;  af..dehl/.... different


	INCLUDE	"graphics/grafix.inc"

                XLIB    stencil_add_pixel
                XDEF	stencil_ptr
                XREF	coords
                
                LIB		l_cmp

.stencil_ptr	defw	0


.stencil_add_pixel
		push    hl
		ld      hl,maxy
		call    l_cmp
		pop     hl
		ret     nc               ; Return if Y overflows

		push    de
		ld      de,maxx
		call    l_cmp
		pop     de
		ret     c               ; Return if X overflows

		ld      (coords),hl     ; store X
		ld      (coords+2),de   ; store Y: COORDS must be 2 bytes wider

		push hl			; X
		ld	hl,(stencil_ptr) ; right side vector
		add	hl,de
		add	hl,de		; Y coordinate
		ld	e,(hl)
		inc hl
		ld	d,(hl)
		dec hl
		ex	(sp),hl		; X <-> ptr to stencil
		call	l_cmp	; X > original X ?  [carry set if DE < HL]
		ex	de,hl
		pop hl			; ptr to stencil
		jr	c,noplot
		ld	(hl),e		; yes, update vector
		inc	hl
		ld	(hl),d
		dec hl
.noplot
		push de			; X
		ld	de,maxy*2
		add	hl,de		; move to the right side vector
		;ld	de,(coords)
		;push de
		ld	e,(hl)
		inc hl
		ld	d,(hl)
		dec hl
		ex	(sp),hl		; X <-> ptr to stencil
		call	l_cmp	; X < original X ?   [carry set if DE < HL]
		ex	de,hl
		pop hl			; ptr to stencil
		ret nc
		ld	(hl),e		; yes, update vector
		inc	hl
		ld	(hl),d
		ret
