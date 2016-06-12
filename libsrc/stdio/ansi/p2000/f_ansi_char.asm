;
; 	ANSI Video handling for the P2000T
;
;	Stefano Bodrato - Apr. 2014
;
;	Display a char in location (ansi_ROW),(ansi_COLUMN)
;	A=char to display
;
;
;	$Id: f_ansi_char.asm,v 1.4 2016-06-12 16:06:43 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_CHAR
	
	PUBLIC	text_cols
	PUBLIC	text_rows

	EXTERN	ansi_ROW
	EXTERN	ansi_COLUMN
	
.text_cols   defb 40
.text_rows   defb 25


.ansi_CHAR

	push	af
	ld	a,4
	call $60C0
	
	ld	a,(ansi_ROW)
	inc a
	call $60C0

	ld	a,(ansi_COLUMN)
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

	ld	a,(ansi_ROW)
	inc a
	call $60C0

	ld	a,(ansi_COLUMN)
	inc a
	jp $60C0
