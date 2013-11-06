;
; 	ANSI Video handling for the Sharp X1
;	Karl Von Dyson (for X1s.org) - 24/10/2013
;	Stefano Bodrato 10/2013
;
;	set it up with:
;	.text_cols	= max columns
;	.text_rows	= max rows
;
;	Display a char in location (ansi_ROW),(ansi_COLUMN)
;	A=char to display
;
;
;	$Id: f_ansi_char.asm,v 1.2 2013-11-06 09:40:35 stefano Exp $
;

	XLIB	ansi_CHAR
	
	XDEF	text_cols
	XDEF	text_rows

	XDEF	ATTR

	XREF	ansi_ROW
	XREF	ansi_COLUMN
	
	
.text_cols   defb 40
.text_rows   defb 25


.ansi_CHAR

	push	af
	ld	hl,$3000
	ld	a,(ansi_ROW)
	and	a
	jr	z,r_zero
	ld	b,a
	ld	de,40
.r_loop
	add	hl,de
	djnz	r_loop
.r_zero
	ld	a,(ansi_COLUMN)
	ld	d,0
	ld	e,a
	add	hl,de
	pop	af
	

.setout

	ld	(hl),a
	
	ld b,h
	ld c,l
	out(c),a

	res 4,b
.ATTR
	ld	a,15
	out(c),a

	ret
