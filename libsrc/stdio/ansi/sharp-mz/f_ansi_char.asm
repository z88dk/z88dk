;
; 	ANSI Video handling for the SHARP MZ
;
;	set it up with:
;	.text_cols	= max columns
;	.text_rows	= max rows
;
;	Display a char in location (ansi_ROW),(ansi_COLUMN)
;	A=char to display
;
;
;	$Id: f_ansi_char.asm,v 1.2 2001-04-13 14:13:59 stefano Exp $
;

	XLIB	ansi_CHAR
	
	XDEF	text_cols
	XDEF	text_rows

	XREF	ansi_ROW
	XREF	ansi_COLUMN

	XREF	current_attr
	

.text_cols   defb 40
.text_rows   defb 25

; 0=space
; 1=A..Z
; 128=a..z
; 32=0..9
; 96=!..

.ansi_CHAR

	cp	32
	jr	nz,nospace
	xor	a
	jr	setout
.nospace
	cp	48	; Between 0 and 9 ?
	jr	c,isntnum
	cp	58
	jr	nc,isntnum
	sub	16	; Ok, re-code to the Sharp Display set
	jr	setout	; .. and put it out
.isntnum
	cp	97	; Between a and z ?
	jr	c,isntlower
	cp	123
	jr	nc,isntlower
	add	a,32
	jr	setout
.isntlower
	cp	65	; Between A and Z ?
	jr	c,isntchar
	cp	91
	jr	nc,isntchar
	sub	64
	jr	setout
.isntchar
	add	a,63 ; For now...
	
.setout
	push	af
	ld	hl,$D000
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
	
	ld	a,8	; Set the character color
	add	a,h
	ld	h,a
	ld	a,(current_attr)
	ld	(hl),a
	
	ret

