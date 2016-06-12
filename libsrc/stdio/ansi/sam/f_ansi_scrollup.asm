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
;	$Id: f_ansi_scrollup.asm,v 1.3 2016-06-12 16:06:43 dom Exp $
;

        SECTION code_clib	
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
