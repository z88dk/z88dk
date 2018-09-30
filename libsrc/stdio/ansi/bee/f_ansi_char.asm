;
; 	ANSI Video handling for the Microbee
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
	EXTERN	generic_console_printc
	EXTERN	__console_x
	EXTERN	INVRS

.ansi_CHAR
	ld	hl,INVRS		;TODO: really?
	or	(HL)
	ld	d,a
	ld	bc,(__console_x)
	ld	e,1
	call	generic_console_printc
	ret
