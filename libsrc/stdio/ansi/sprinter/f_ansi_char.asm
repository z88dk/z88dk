;
;       Sprinter C Library
;
; 	ANSI Video handling for Sprinter
;
;	$Id: f_ansi_char.asm,v 1.1 2002-10-10 20:38:22 dom Exp $
;

	XLIB	ansi_CHAR
	
	XREF	ansi_ROW
	XREF	ansi_COLUMN

	XDEF	text_cols
	XDEF	text_rows

	XREF	text_attr
	

.text_rows   defb 32
.text_cols   defb 80

; a = character to print - need to handle attributes
.ansi_CHAR
	ex	af,af
	ld	a,(ansi_ROW)
	ld	d,a
	ld	a,(ansi_COLUMN)
	ld	e,a	
	ld	a,(text_attr)
	ld	b,a
	ex	af,af
	ld	c,$58		;PUTCHAR
	rst	$10
	ret
