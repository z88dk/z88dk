;
; 	ANSI Video handling for the SHARP MZ
;
;	set it up with:
;	.__console_w	= max columns
;	.__console_h	= max rows
;
;	Display a char in location (__console_y),(__console_x)
;	A=char to display
;
;
;	$Id: f_ansi_char.asm,v 1.6 2016-06-12 16:06:43 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_CHAR
	
	EXTERN	__console_y
	EXTERN	__console_x

	EXTERN	current_attr
	EXTERN	sharpmz_from_ascii
	

; 0=space
; 1=A..Z
; 128=a..z
; 32=0..9
; 96=!..

.ansi_CHAR
	call	sharpmz_from_ascii
.setout
	ld	hl,$D000 - 40
	ld	bc,(__console_x)
	inc	b
	ld	de,40
.r_loop
	add	hl,de
	djnz	r_loop
.r_zero
	add	hl,bc
	ld	(hl),a
	
	ld	a,8	; Set the character color
	add	a,h
	ld	h,a
	ld	a,(current_attr)
	ld	(hl),a
	ret

