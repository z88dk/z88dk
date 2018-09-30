;
; 	ANSI Video handling for the Sharp X1
;	Karl Von Dyson (for X1s.org) - 24/10/2013
;	Stefano Bodrato 10/2013
;
;	set it up with:
;	.__console_w	= max columns
;	.__console_h	= max rows
;
;	Display a char in location (__console_y),(__console_x)
;	A=char to display
;
;
;	$Id: f_ansi_char.asm,v 1.7 2016-07-20 05:45:02 stefano Exp $
;

        SECTION code_clib
	PUBLIC	ansi_CHAR
	

	EXTERN	__x1_attr
	EXTERN	__console_y
	EXTERN	__console_x
	EXTERN	__console_w
	

.ansi_CHAR

	push	af
	ld	hl,$3000
	ld	a,(__console_y)
	and	a
	jr	z,r_zero
	ld	b,a
	ld	d,l
	ld	a,(__console_w)
	ld	e,a
.r_loop
	add	hl,de
	djnz	r_loop
.r_zero
	ld	a,(__console_x)
	ld	d,0
	ld	e,a
	add	hl,de
	pop	af
	

.setout

	ld b,h
	ld c,l
	out(c),a

	res 4,b
	ld	a,(__x1_attr)
	out(c),a

	ret
