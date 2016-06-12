;
; 	ANSI Video handling for the Sharp MZ
;
; 	CLS - Clear the screen
;	
;
;	Stefano Bodrato - Maj 2000
;
;
;	$Id: f_ansi_cls.asm,v 1.4 2016-06-12 16:06:43 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_cls

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
	
