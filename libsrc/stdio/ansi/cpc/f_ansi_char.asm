;
; 	ANSI Video handling for the Amstrad CPC
;
; 	Handles colors referring to current PAPER/INK/etc. settings
;
;	set it up with:
;	.text_cols	= max columns
;	.text_rows	= max rows
;
;	Display a char in location (ansi_ROW),(ansi_COLUMN)
;	A=char to display
;
;
;	$Id: f_ansi_char.asm,v 1.1 2004-07-15 10:03:49 stefano Exp $
;

	XLIB	ansi_CHAR
	
	XREF	ansi_ROW
	XREF	ansi_COLUMN

	XDEF	text_cols
	XDEF	text_rows

	XREF	INVRS
	XREF	UNDRL
	
.text_cols   defb 80

.text_rows   defb 25

.ansi_CHAR
	ld	e,a
	ld	a,(ansi_COLUMN)
	inc	a
	ld	h,a
	ld	a,(ansi_ROW)
	inc	a
	ld	l,a
	push	hl
	call	$BB75
	ld	a,e
	call	$BB5A
	pop	hl
	ld	a,(UNDRL)
	and	a
	ret	z

	call	$BB75
	ld	a,1
	call	$BB9F	; Transparent Text mode
	ld	a,'_'
	call	$BB5A
	xor	a
	jp	$BB9F	; Opaque Text mode

