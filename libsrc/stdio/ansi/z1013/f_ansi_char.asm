;
; 	ANSI Video handling for the Robotron Z1013
;
;	Stefano Bodrato - Aug 2016
;
;
;	Display a char in location (ansi_ROW),(ansi_COLUMN)
;	A=char to display
;
;
;	$Id: f_ansi_char.asm,v 1.1 2016-08-05 07:04:10 stefano Exp $
;

        SECTION  code_clib
	PUBLIC	ansi_CHAR
	
	PUBLIC	text_cols
	PUBLIC	text_rows

	EXTERN	ansi_ROW
	EXTERN	ansi_COLUMN
	
	EXTERN	z1013_inverse


.text_cols   defb 32
.text_rows   defb 32


.ansi_CHAR

	ld	hl,z1013_inverse
	or	(hl)

.setout
	push	af
	ld	hl,$EC00
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

