;
; 	ANSI Video handling for the VZ200
;
; 	CLS - Clear the screen
;	
;
;	Stefano Bodrato - Apr. 2000
;
;
;	$Id: f_ansi_cls.asm,v 1.5 2016-06-10 23:56:01 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_cls

.ansi_cls
	ld	a,0
	ld	(6800h),a	; force TEXT mode

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
	
