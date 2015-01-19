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
;	$Id: f_ansi_scrollup.asm,v 1.2 2015-01-19 01:33:19 pauloscustodio Exp $
;

	
	PUBLIC	ansi_SCROLLUP	
	EXTERN	ansi_default
	EXTERN	ansi_restore
			
.ansi_SCROLLUP
	call	ansi_default

	ld	a,10		; LF
	rst	16
	ld	a,13		; CR
	rst	16

	jp	ansi_restore
