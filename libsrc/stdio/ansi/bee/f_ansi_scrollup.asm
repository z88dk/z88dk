;
; 	ANSI Video handling for the the MicroBEE
;
;	Stefano Bodrato - 2016
;
; 	Handles colors referring to current PAPER/INK/etc. settings
;
;	Scrollup
;
;
;	$Id: f_ansi_scrollup.asm,v 1.1 2016-11-15 08:11:11 stefano Exp $
;

        SECTION  code_clib
	PUBLIC	ansi_SCROLLUP
	EXTERN	bee_attr


.ansi_SCROLLUP
	ld	hl,$f000+80
	ld	de,$f000
	ld	bc,80*24
	ldir
	ld	hl,$F000+80*24
	ld	(hl),32 ;' '
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,79
	ldir
	
	ld	a,64
	out (8),a
	ld a,(bee_attr)
	ld	hl,$f800+80
	ld	de,$f800
	ld	bc,80*24
	ldir
	ld	hl,$F800+80*24
	ld	(hl),a
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,79
	ldir
	xor a
	out (8),a

	ret
