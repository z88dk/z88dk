;
;       SAM Coupé C Library
;
; 	ANSI Video handling for SAM Coupé
;
;
; 	Clean a text line
;
;	Stefano Bodrato - Apr. 2000
;
; in:	A = text row number
;
;
;	$Id: f_ansi_dline.asm,v 1.1 2003-02-04 09:10:24 stefano Exp $
;

	XLIB	ansi_del_line
 	LIB	ansi_default
	LIB	ansi_restore	
	
	XREF	ansi_ROW
	
.ansi_del_line
 	ld	(ansi_ROW),a

	call	ansi_default
	ld	b,32
.line
	ld	a,' '
	rst	16
	djnz	line

	jp	ansi_restore
	
