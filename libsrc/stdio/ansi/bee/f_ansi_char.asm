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
;	$Id: f_ansi_char.asm,v 1.1 2016-11-15 08:11:11 stefano Exp $
;

        SECTION  code_clib
	PUBLIC	ansi_CHAR
	
	PUBLIC	text_cols
	PUBLIC	text_rows

	EXTERN	ansi_ROW
	EXTERN	ansi_COLUMN
	
	EXTERN	bee_attr


.text_cols   defb 80
.text_rows   defb 25


.ansi_CHAR


.setout
	push	af
	ld	hl,$F000
	ld	a,(ansi_ROW)
	and	a
	jr	z,r_zero
	ld	b,a
	ld	de,80
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

	ld	a,64
	out (8),a
	ld de,$800
	add hl,de
	ld a,(bee_attr)
	ld (hl),a
	xor a
	out (8),a
	
	ret

