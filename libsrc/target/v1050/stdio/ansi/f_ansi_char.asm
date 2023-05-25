;
; 	ANSI Video handling for the Visual 1050
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


.ansi_CHAR
		jp generic_console_printc
