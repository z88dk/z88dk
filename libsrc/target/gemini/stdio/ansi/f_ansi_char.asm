;
; 	ANSI Video handling for the Gemini Galaxy
;
;	set it up with:
;	.__console_w	= max columns
;	.__console_h	= max rows
;
;	Display a char in location (__console_y),(__console_x)
;	A=char to display
;
;
;	$Id: f_ansi_char.asm $
;

        SECTION  code_clib
	PUBLIC	ansi_CHAR
	EXTERN	generic_console_printc
	EXTERN	__console_x
	EXTERN	INVRS

.ansi_CHAR
	ld	hl,INVRS		;TODO: really?
	ld  d,a
	xor a
	add (hl)
	ld  a,d
	jr  z,no_inverse
	add 144-32
.no_inverse
	ld	d,a
	ld	bc,(__console_x)
	ld	e,1
	call	generic_console_printc
	ret
