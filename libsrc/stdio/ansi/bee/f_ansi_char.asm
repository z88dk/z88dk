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
;	$Id: f_ansi_char.asm,v 1.2 2016-11-17 09:39:03 stefano Exp $
;

        SECTION  code_clib
	PUBLIC	ansi_CHAR
	

	EXTERN	__console_y
	EXTERN	__console_x
	EXTERN	__console_w
	
	EXTERN	bee_attr
	EXTERN	INVRS


.ansi_CHAR

.setout
	ld hl,INVRS
	or (HL)
	push	af
	ld	hl,$F000
	ld	a,(__console_y)
	and	a
	jr	z,r_zero
	
	ld	b,a
	ld	de,(__console_w)
	ld	d,0
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

	ld	a,64
	out (8),a
	ld de,$800
	add hl,de
	ld a,(bee_attr)
	ld (hl),a
	xor a
	out (8),a
	
	ret

