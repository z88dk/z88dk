;
; 	ANSI Video handling for the Sharp MZ
;
; 	Handles colors referring to current PAPER/INK/etc. settings
;
;	Scrollup
;

	XLIB	ansi_SCROLLUP


.ansi_SCROLLUP
	ld	hl,$D028
	ld	de,$D000
	ld	bc,960
	ldir
	ld	hl,$D000+960
	ld	(hl),0 ;' '
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,39
	ldir

	ld	hl,$D828
	ld	de,$D800
	ld	bc,960
	ldir
	ld	hl,$D800+960
	ld	(hl),$70
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,39
	ldir
	
	ret
 