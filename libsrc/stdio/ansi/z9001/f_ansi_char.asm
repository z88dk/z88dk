;
; 	ANSI Video handling for the Robotron Z9001
;
;	Stefano Bodrato - Sept. 2016
;
;
;	Display a char in location (__console_y),(__console_x)
;	A=char to display
;
;
;	$Id: f_ansi_char.asm,v 1.1 2016-09-23 06:21:35 stefano Exp $
;

        SECTION  code_clib
	PUBLIC	ansi_CHAR
	
	EXTERN	__console_y
	EXTERN	__console_x
	
	EXTERN	__z9001_attr



.ansi_CHAR

.setout
	push	af
	ld	hl,$EC00
	ld	a,(__console_y)
	and	a
	jr	z,r_zero
	ld	b,a
	ld	de,40
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
	ld  de,-1024	; Colour attribute map
	add hl,de
	ld a,(__z9001_attr)
	ld (hl),a
	
	ret

