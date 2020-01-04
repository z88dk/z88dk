;
; 	ANSI Video handling for the Mattel Aquarius
;
;	set it up with:
;	.__console_w	= max columns
;	.__console_h	= max rows
;
;	Display a char in location (__console_y),(__console_x)
;	A=char to display
;
;
;	$Id: f_ansi_char.asm,v 1.3 2016-04-04 18:31:22 dom Exp $
;

        SECTION  code_clib
	PUBLIC	ansi_CHAR
	
	EXTERN	__console_y
	EXTERN	__console_x
	
	EXTERN	__aquarius_attr

.ansi_CHAR

	push	af
	ld	hl,$3000
	ld	a,(__console_y)
	inc	a	; we skip the first line to avoid border problems
	ld	b,a
	ld	de,40
.r_loop
	add	hl,de
	djnz	r_loop
	ld	a,(__console_x)
	ld	d,0
	ld	e,a
	add	hl,de
	pop	af
	ld	(hl),a
	
	ld	de,1000+24
	add	hl,de
	ld	a,(__aquarius_attr)
	ld	(hl),a

	ret

