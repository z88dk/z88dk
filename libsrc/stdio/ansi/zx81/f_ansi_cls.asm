;
; 	ANSI Video handling for the ZX81
;	By Stefano Bodrato - Sept 2007
;
; 	CLS - Clear the screen
;	
;
;	$Id: f_ansi_cls.asm,v 1.4 2014-10-29 16:16:54 stefano Exp $
;

	XLIB	ansi_cls
	LIB	_clg_hr		; we use the graphics CLS routine
IF MTHRG
	XREF	text_rows
	XREF	MTCH_P2
ENDIF

.ansi_cls
	call	_clg_hr
IF MTHRG
	ld	a,(MTCH_P2+2)
	srl a
	srl a
	srl a
	ld	(text_rows),a
ENDIF

	ret
