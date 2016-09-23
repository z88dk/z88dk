;
; 	ANSI Video handling for the Robotron Z9001
;
;	Stefano Bodrato - Sept. 2016
;
;
;	Display a char in location (ansi_ROW),(ansi_COLUMN)
;	A=char to display
;
;
;	$Id: f_ansi_char.asm,v 1.1 2016-09-23 06:21:35 stefano Exp $
;

        SECTION  code_clib
	PUBLIC	ansi_CHAR
	
	PUBLIC	text_cols
	PUBLIC	text_rows

	EXTERN	ansi_ROW
	EXTERN	ansi_COLUMN
	
	EXTERN	z9001_attr


.text_cols   defb 40
.text_rows   defb 24


.ansi_CHAR

.setout
	push	af
	ld	hl,$EC00
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
	ld	(hl),a
	ld  de,-1024	; Colour attribute map
	add hl,de
	ld a,(z9001_attr)
	ld (hl),a
	
	ret

