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
;	$Id: f_ansi_scrollup.asm,v 1.2 2016-11-17 09:39:03 stefano Exp $
;

        SECTION  code_clib
	PUBLIC	ansi_SCROLLUP
	EXTERN	bee_attr
	EXTERN	ansicolumns


.ansi_SCROLLUP
	ld	hl,$f000+ansicolumns
	ld	de,$f000
	ld	bc,ansicolumns*24
	ldir
	ld	hl,$F000+ansicolumns*24
	ld	(hl),32 ;' '
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,ansicolumns-1
	ldir
	
	ld	a,64
	out (8),a
	ld a,(bee_attr)
	ld	hl,$f800+ansicolumns
	ld	de,$f800
	ld	bc,ansicolumns*24
	ldir
	ld	hl,$F800+ansicolumns*24
	ld	(hl),a
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,ansicolumns-1
	ldir
	xor a
	out (8),a

	ret
