;
; 	ANSI Video handling for the Galaksija
;	By Stefano Bodrato - 2017
;
;	set it up with:
;	.__console_w	= max columns
;	.__console_h	= max rows
;
;	Display a char in location (__console_y),(__console_x)
;	A=char to display
;
;
;	$Id: f_ansi_char.asm $
;

        SECTION code_clib
	PUBLIC	ansi_CHAR
		
	EXTERN	__console_y
	EXTERN	__console_x
	
;	EXTERN	gal_inverse


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
	ld	a,(__console_y)
	and	a
	jr	z,r_zero
	ld	b,a
	ld	de,32
.r_loop
	add	hl,de
	djnz	r_loop
.r_zero
	ld	a,(__console_x)
	ld	d,0
	ld	e,a
	add	hl,de
	pop	af
	ld	(hl),a
	ret
	
;	SECTION	bss_clib
;.char
;defb 0
