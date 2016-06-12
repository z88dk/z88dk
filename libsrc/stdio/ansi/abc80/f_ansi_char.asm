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
;	A slower (but working) method it commented out
;
;
;	$Id: f_ansi_char.asm,v 1.5 2016-06-12 16:06:42 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_CHAR
	

	EXTERN	ansi_ROW
	EXTERN	ansi_COLUMN
	
	PUBLIC	text_cols
	PUBLIC	text_rows
.text_cols   defb 40
.text_rows   defb 24


.ansi_CHAR
	push	af

	ld	a,(ansi_ROW)

	ld	hl,884		; ROW table in ROM
	ld	d,0
	rla
	ld	e,a
	add	hl,de
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	
;	ld	hl,31744	; OLD method (non ROM dependent)
;	cp	8
;	jr	c,jpvdu
;	ld	hl,31784
;	sub	8
;	cp	8
;	jr	c,jpvdu
;	ld	hl,31824
;	sub	8
;.jpvdu
;	and	a
;	jr	z,r_zero
;	ld	b,a
;	ld	de,128
;.r_loop
;	add	hl,de
;	djnz	r_loop

.r_zero
	ld	a,(ansi_COLUMN)
;	ld	d,0
	ld	e,a
	add	hl,de

	pop	af
	ld	(hl),a
	ret
