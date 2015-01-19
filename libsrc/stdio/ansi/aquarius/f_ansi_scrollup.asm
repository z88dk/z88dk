;
; 	ANSI Video handling for the Mattel Aquarius
;
; 	Handles colors
;
;	Scrollup
;
;	Stefano Bodrato - Dec. 2001
;
;	$Id: f_ansi_scrollup.asm,v 1.2 2015-01-19 01:33:18 pauloscustodio Exp $
;

	PUBLIC	ansi_SCROLLUP
	EXTERN	aquarius_attr


.ansi_SCROLLUP
	ld	hl,$3050
	ld	de,$3028
	ld	bc,920
	ldir
	ld	h,d
	ld	l,e
	ld	(hl),32 ;' '
	inc	de
	ld	bc,39
	ldir

	ld	hl,$3450
	ld	de,$3428
	ld	bc,920
	ldir
	ld	h,d
	ld	l,e
	;ld	a,(aquarius_attr)
	ld	a,$70
	ld	(hl),a
	inc	de
	ld	bc,39
	ldir
	
	ret
 