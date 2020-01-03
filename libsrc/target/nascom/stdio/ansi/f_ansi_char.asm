;
;	ANSI Video handling for the NASCOM1/2
;
;	set it up with:
;	.__console_w	= max columns
;	.__console_h	= max rows
;
;	Display a char in location (__console_y),(__console_x)
;	A=char to display
;
;	Stefano Bodrato - Jul 2004
;
;
;	$Id: f_ansi_char.asm,v 1.5 2016-06-12 16:06:42 dom Exp $
;

	SECTION	code_clib
	PUBLIC	ansi_CHAR


	EXTERN	__console_y
	EXTERN	__console_x


.ansi_CHAR

	push	af
	ld	a,(__console_y)
	ld	hl,0BCAh
	and	a
	jr	z,gotline

;	ld	hl,$84a
	ld	hl,$80a
	dec	a
	jr	z,gotline

	ld	de,64
.r_loop
	add	hl,de
	dec	a
	jr	nz,r_loop

.gotline
	ld	a,(__console_x)
	ld	d,0
	ld	e,a
	add	hl,de
	pop	af
	ld	(hl),a

	;ld	a,(nascom_attr)

	ret
