;
; 	ANSI Video handling for the VZ200
;
; 	CLS - Clear the screen
;	
;
;	Stefano Bodrato - Apr. 2000
;

	XLIB	ansi_cls

.ansi_cls
	ld	hl,$7000
	ld	(hl),32 ;' '
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,511
	ldir
;;;
;;; The ROM cls call:
;;;	call	457
;;;

	ret
	