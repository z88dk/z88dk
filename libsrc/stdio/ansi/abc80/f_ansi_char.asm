;
; 	ANSI Video handling for the ABC80
;
;	set it up with:
;	.text_cols	= max columns
;	.text_rows	= max rows
;
;	Display a char in location (ansi_ROW),(ansi_COLUMN)
;	A=char to display
;

	XLIB	ansi_CHAR
	
	XDEF	text_cols
	XDEF	text_rows

	XREF	ansi_ROW
	XREF	ansi_COLUMN
	
.text_cols   defb 40
.text_rows   defb 24


.ansi_CHAR
	push	af
	ld	hl,31744
	ld	a,(ansi_ROW)
	push	af
	ld	de,0
	rra
	rra
	rra
	rra
	rr	e
	rra
	rr	e
	add	hl,de
	pop	af
	and	7
	and	a
	jr	z,r_zero
	ld	b,a
	ld	de,128
.r_loop
	add	hl,de
	djnz	r_loop
.r_zero
	ld	a,(ansi_COLUMN)
	ld	d,0
	ld	e,a
	add	hl,de
	pop	af
	ld	(hl),a
	ret

