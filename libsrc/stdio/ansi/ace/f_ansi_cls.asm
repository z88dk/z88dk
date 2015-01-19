;
; 	ANSI Video handling for the Jupiter ACE
;
; 	CLS - Clear the screen
;	
;
;	Stefano Bodrato - Feb. 2001
;
;
;	$Id: f_ansi_cls.asm,v 1.3 2015-01-19 01:33:18 pauloscustodio Exp $
;

	PUBLIC	ansi_cls

.ansi_cls
	ld	hl,$2400
	ld	(hl),32 ;' '
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,32*24
	ldir
;;;
;;; The ROM cls call:
;;;	call	457
;;;

	ret
