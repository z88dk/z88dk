;
; 	ANSI Video handling for the Sharp MZ
;
; 	CLS - Clear the screen
;	
;
;	Stefano Bodrato - Maj 2000
;

	XLIB	ansi_cls

.ansi_cls
	ld	hl,$D000
	ld	(hl),0 ;' '
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,40*25
	ldir

	ld	hl,$D800
	ld	(hl),$70
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,40*25
	ldir

;	ld	(hl),$70
;	ld	bc,40*25
;	ldir
	ret
	