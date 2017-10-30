;
; 	ANSI Video handling for the Galaksija
;	By Stefano Bodrato - 2017
;
;	set it up with:
;	.text_cols	= max columns
;	.text_rows	= max rows
;
;	Display a char in location (ansi_ROW),(ansi_COLUMN)
;	A=char to display
;
;
;	$Id: f_ansi_char.asm $
;

        SECTION code_clib
	PUBLIC	ansi_CHAR
		
	PUBLIC	text_cols
	PUBLIC	text_rows

	EXTERN	ansi_ROW
	EXTERN	ansi_COLUMN
	
;	EXTERN	gal_inverse

.text_cols   defb 32
.text_rows   defb 16


.ansi_CHAR
;	ld	hl,char
;	ld	(hl),a
;	bit	 6,a		; filter the dangerous codes
;	ret	 nz

	
	; Some undercase text?  Transform in UPPER !
	cp	97
	jr	c,nounder
	sub	32
.nounder
;	ld	hl,gal_inverse
;	or	(hl)

	push	af
	ld	hl,$2800
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
	
;	SECTION	bss_clib
;.char
;defb 0
