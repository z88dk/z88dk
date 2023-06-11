;
; 	ANSI Video handling for the Alphatronic
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

.ansi_CHAR
	ld	bc,(__console_x)
	ld	e,1
	call	generic_console_printc
	ret
