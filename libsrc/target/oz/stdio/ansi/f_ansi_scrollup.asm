;
; 	ANSI Video handling for Sharp OZ family
;
;	Scrollup
;
;	Stefano Bodrato - Nov. 2002
;
;	$Id: f_ansi_scrollup.asm,v 1.6 2016-06-12 16:06:43 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_SCROLLUP

	EXTERN	base_graphics

	EXTERN     swapgfxbk
        EXTERN	swapgfxbk1


.ansi_SCROLLUP

	call	swapgfxbk

        ld      hl,(base_graphics)
        ld	d,h
        ld	e,l
        ld	bc,0f0h
        add	hl,bc

        ld      bc,2160
	;ld	bc,2160-0f0h
        ldir

	ld	de,0f0h
	sbc	hl,de

	ld	d,h
	ld	e,l
	xor	a
	ld	(hl),a
	inc	de
	ld	bc,+(30*8)-1
	ldir

	jp	swapgfxbk1
