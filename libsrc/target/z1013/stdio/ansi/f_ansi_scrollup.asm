;
; 	ANSI Video handling for the Robotron Z1013
;
;	Stefano Bodrato - Aug 2016
;
;	Scrollup
;
;
;	$Id: f_ansi_scrollup.asm,v 1.1 2016-08-05 07:04:10 stefano Exp $
;

        SECTION  code_clib
	PUBLIC	ansi_SCROLLUP


.ansi_SCROLLUP
	ld	hl,$EC00+32
	ld	de,$EC00
	ld	bc,32*31
	ldir
	ld	hl,$EC00+32*31
	ld	(hl),32 ;' '
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,31
	ldir
	ret
