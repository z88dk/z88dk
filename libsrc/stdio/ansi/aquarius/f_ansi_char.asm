;
; 	ANSI Video handling for the Mattel Aquarius
;
;	set it up with:
;	.text_cols	= max columns
;	.text_rows	= max rows
;
;	Display a char in location (ansi_ROW),(ansi_COLUMN)
;	A=char to display
;
;
;	$Id: f_ansi_char.asm,v 1.1 2001-12-27 09:35:57 stefano Exp $
;

	XLIB	ansi_CHAR
	
	XDEF	text_cols
	XDEF	text_rows

	XREF	ansi_ROW
	XREF	ansi_COLUMN
	
	XREF	aquarius_attr

.text_cols   defb 40
.text_rows   defb 24


.ansi_CHAR

	push	af
	ld	hl,$3000
	ld	a,(ansi_ROW)
	inc	a	; we skip the first line to avoid border problems
	ld	b,a
	ld	de,40
.r_loop
	add	hl,de
	djnz	r_loop
	ld	a,(ansi_COLUMN)
	ld	d,0
	ld	e,a
	add	hl,de
	pop	af
	ld	(hl),a
	
	ld	de,1000+24
	add	hl,de
	ld	a,(aquarius_attr)
	ld	(hl),a

	ret

