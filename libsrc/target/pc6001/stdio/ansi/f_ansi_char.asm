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
	
	EXTERN	__console_x
	EXTERN	generic_console_printc
	


.ansi_CHAR
	ld	bc,(__console_x)
	ld	d,a
	ld	e,0
	jp	generic_console_printc

