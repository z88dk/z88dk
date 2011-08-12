;
; 	ANSI Video handling for Sharp OZ family
;
;	Scrollup
;
;	Stefano Bodrato - Nov. 2002
;
;	$Id: f_ansi_scrollup.asm,v 1.3 2011-08-12 20:42:23 pauloscustodio Exp $
;

	XLIB	ansi_SCROLLUP

	XREF	base_graphics

	LIB     swapgfxbk
        XREF	swapgfxbk1


.ansi_SCROLLUP

	call	swapgfxbk

        ld      hl,(base_graphics)
        ld	d,h
        ld	e,l
        ld	bc,f0h
        add	hl,bc

        ld      bc,2160
	;ld	bc,2160-f0h
        ldir

	ld	de,f0h
	sbc	hl,de

	ld	d,h
	ld	e,l
	xor	a
	ld	(hl),a
	inc	de
	ld	bc,+(30*8)-1
	ldir

	jp	swapgfxbk1
