;
; 	ANSI Video handling for the Robotron Z9001
;
;	Stefano Bodrato - Sept. 2016
;
;	Scrollup
;
;
;	$Id: f_ansi_scrollup.asm,v 1.1 2016-09-23 06:21:35 stefano Exp $
;

        SECTION  code_clib
	PUBLIC	ansi_SCROLLUP


.ansi_SCROLLUP
	ld	hl,$EC00+40
	ld	de,$EC00
	ld	bc,40*23
	ldir
	ld	hl,$EC00+40*23
	ld	(hl),32 ;' '
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,23
	ldir

	ld	hl,$E800+40
	ld	de,$E800
	ld	bc,40*23
	ldir
	ld	hl,$E800+40*23
	ld	(hl),7*16	; reset bottom line attributes
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,23
	ldir

	ret
