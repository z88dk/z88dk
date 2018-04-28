;
; 	ANSI Video handling for the PC6001
;
;	set it up with:
;	.__console_w	= max columns
;	.__console_h	= max rows
;
;	Display a char in location (__console_y),(__console_x)
;	A=char to display
;
;
;	$Id: f_ansi_char.asm,v 1.3 2016-06-12 16:06:43 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_CHAR
	
	EXTERN	__console_y
	EXTERN	__console_x
	
	EXTERN	pc6001_attr


.ansi_CHAR

	push	af
	ld	a,(__console_y)
	inc	a
	ld	l,a
	ld	a,(__console_x)
	inc	a
	ld	h,a
	CALL 11CDh      ; L2A - convert location to screen address
	pop	af
	
	cp	97	; Between a and z ?
	jr	c,isntlower
	cp	123
	jr	nc,isntlower
	add	a,32

.isntlower
	ld	(hl),a
	
	ld	a,$E0
	and	h
	ld	h,a
	ld	a,(pc6001_attr)
	ld	(hl),a
	ret

