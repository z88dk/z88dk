;
; 	ANSI Video handling for the Robotron Z1013
;
;	Stefano Bodrato - Aug 2016
;
;
;	Display a char in location (__console_y),(__console_x)
;	A=char to display
;
;
;	$Id: f_ansi_char.asm,v 1.1 2016-08-05 07:04:10 stefano Exp $
;

        SECTION  code_clib
	PUBLIC	ansi_CHAR
	
	EXTERN	__console_y
	EXTERN	__console_x
	
	EXTERN	z1013_inverse



.ansi_CHAR

	ld	hl,z1013_inverse
	or	(hl)

.setout
	push	af
	ld	hl,$EC00
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

