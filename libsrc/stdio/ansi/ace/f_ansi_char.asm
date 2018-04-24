;
; 	ANSI Video handling for the Jupiter ACE
;
;	Stefano Bodrato - Feb. 2001
;
;
;	set it up with:
;	.__console_w	= max columns
;	.__console_h	= max rows
;
;	Display a char in location (__console_y),(__console_x)
;	A=char to display
;
;
;	$Id: f_ansi_char.asm,v 1.6 2016-04-04 18:31:22 dom Exp $
;

        SECTION  code_clib
	PUBLIC	ansi_CHAR
	
	EXTERN	__console_y
	EXTERN	__console_x
	
	EXTERN	ace_inverse



.ansi_CHAR

	ld	hl,ace_inverse
	or	(hl)

.setout
	push	af
	ld	hl,$2400
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

