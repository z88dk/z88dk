;
; 	ANSI Video handling for the P2000T
;
;	Stefano Bodrato - Apr. 2014
;
;	Display a char in location (__console_y),(__console_x)
;	A=char to display
;
;
;	$Id: f_ansi_char.asm,v 1.4 2016-06-12 16:06:43 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_CHAR
	

	EXTERN	__console_y
	EXTERN	__console_x
	

.ansi_CHAR

	push	af
	ld	a,4
	call $60C0
	
	ld	a,(__console_y)
	inc a
	call $60C0

	ld	a,(__console_x)
	inc a
	call $60C0

	pop	af

	cp 95
	jr nz,nounderscore
	ld a,92
nounderscore:

	call $60C0

; adjust the cursor position
	ld	a,4
	call $60C0

	ld	a,(__console_y)
	inc a
	call $60C0

	ld	a,(__console_x)
	inc a
	jp $60C0
