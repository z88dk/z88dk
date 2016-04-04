;
; 	ANSI Video handling for the Jupiter ACE
;
;	Stefano Bodrato - Feb. 2001
;
;
;	set it up with:
;	.text_cols	= max columns
;	.text_rows	= max rows
;
;	Display a char in location (ansi_ROW),(ansi_COLUMN)
;	A=char to display
;
;
;	$Id: f_ansi_char.asm,v 1.6 2016-04-04 18:31:22 dom Exp $
;

        SECTION  code_clib
	PUBLIC	ansi_CHAR
	
	PUBLIC	text_cols
	PUBLIC	text_rows

	EXTERN	ansi_ROW
	EXTERN	ansi_COLUMN
	
	EXTERN	ace_inverse


.text_cols   defb 32
.text_rows   defb 24


.ansi_CHAR

	ld	hl,ace_inverse
	or	(hl)

.setout
	push	af
	ld	hl,$2400
	ld	a,(ansi_ROW)
	and	a
	jr	z,r_zero
	ld	b,a
	ld	de,32
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

