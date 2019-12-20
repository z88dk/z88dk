;
; 	ANSI Video handling for the VZ200
;
; 	Handles colors referring to current PAPER/INK/etc. settings
;
;	Scrollup
;
;
;	$Id: f_ansi_scrollup.asm,v 1.4 2016-06-10 23:56:01 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_SCROLLUP


.ansi_SCROLLUP
	ld	hl,$7020
	ld	de,$7000
	ld	bc,480
	ldir
	ld	hl,$7000+480
	ld	(hl),32 ;' '
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,31
	ldir
	ret
 
