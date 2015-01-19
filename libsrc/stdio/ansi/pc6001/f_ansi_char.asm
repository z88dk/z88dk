;
; 	ANSI Video handling for the PC6001
;
;	set it up with:
;	.text_cols	= max columns
;	.text_rows	= max rows
;
;	Display a char in location (ansi_ROW),(ansi_COLUMN)
;	A=char to display
;
;
;	$Id: f_ansi_char.asm,v 1.2 2015-01-19 01:33:19 pauloscustodio Exp $
;

	PUBLIC	ansi_CHAR
	
	PUBLIC	text_cols
	PUBLIC	text_rows

	EXTERN	ansi_ROW
	EXTERN	ansi_COLUMN
	
	EXTERN	pc6001_attr

.text_cols   defb 32
.text_rows   defb 16


.ansi_CHAR

	push	af
	ld	a,(ansi_ROW)
	inc	a
	ld	l,a
	ld	a,(ansi_COLUMN)
	inc	a
	ld	h,a
	CALL 11CDh      ; L2A - convert location to screen address
	pop	af
	ld	(hl),a
	
	ld	a,$E0
	and	h
	ld	h,a
	ld	a,(pc6001_attr)
	ld	(hl),a
	ret

