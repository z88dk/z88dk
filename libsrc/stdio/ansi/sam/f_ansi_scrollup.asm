;
;       SAM Coupé C Library
;
; 	ANSI Video handling for SAM Coupé
;
;	Scrolls one line
;
;
;	Frode Tennebø - 29/12/2002
;
;	$Id: f_ansi_scrollup.asm,v 1.1 2003-02-04 09:10:25 stefano Exp $
;

	
	XLIB	ansi_SCROLLUP	
	LIB	ansi_default
	LIB	ansi_restore
			
.ansi_SCROLLUP
	call	ansi_default

	ld	a,10		; LF
	rst	16
	ld	a,13		; CR
	rst	16

	jp	ansi_restore
