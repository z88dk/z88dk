;
; 	ANSI Video handling for the Mattel Aquarius
;
; 	Handles colors
;
;	Scrollup
;
;	Stefano Bodrato - Dec. 2001
;
;	$Id: f_ansi_scrollup.asm,v 1.3 2016-04-04 18:31:22 dom Exp $
;

        SECTION  code_clib
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
 
