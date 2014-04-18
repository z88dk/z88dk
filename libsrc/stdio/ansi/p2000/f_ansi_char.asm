;
; 	ANSI Video handling for the P2000T
;
;	Stefano Bodrato - Apr. 2014
;
;	Display a char in location (ansi_ROW),(ansi_COLUMN)
;	A=char to display
;
;
;	$Id:
;

	XLIB	ansi_CHAR
	
	XDEF	text_cols
	XDEF	text_rows

	XREF	ansi_ROW
	XREF	ansi_COLUMN
	
.text_cols   defb 40
.text_rows   defb 25


.ansi_CHAR

	push	af
	ld	a,4
	call $60C0
	
	ld	a,(ansi_ROW)
	inc a
	call $60C0

	ld	a,(ansi_COLUMN)
	inc a
	call $60C0

	pop	af

	jp $60C0
