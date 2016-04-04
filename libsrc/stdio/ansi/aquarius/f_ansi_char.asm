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
;	$Id: f_ansi_char.asm,v 1.3 2016-04-04 18:31:22 dom Exp $
;

        SECTION  code_clib
	PUBLIC	ansi_CHAR
	
	PUBLIC	text_cols
	PUBLIC	text_rows

	EXTERN	ansi_ROW
	EXTERN	ansi_COLUMN
	
	EXTERN	aquarius_attr

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

