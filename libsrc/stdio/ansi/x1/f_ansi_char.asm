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
;	$Id: f_ansi_char.asm,v 1.7 2016-07-20 05:45:02 stefano Exp $
;

        SECTION code_clib
	PUBLIC	ansi_CHAR
	
	PUBLIC	text_cols
	PUBLIC	text_rows

	PUBLIC	ATTR

	EXTERN	ansi_ROW
	EXTERN	ansi_COLUMN
	
	EXTERN	ansicolumns	
.text_cols   defb ansicolumns
.text_rows   defb 25


.ansi_CHAR

	push	af
	ld	hl,$3000
	ld	a,(ansi_ROW)
	and	a
	jr	z,r_zero
	ld	b,a
	ld	d,l
	ld	a,(text_cols)
	ld	e,a
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
	;ld	a,15
	ld	a,7
	out(c),a

	ret
