;
; 	ANSI Video handling for the Sharp PC G-800 family
;
;	Stefano Bodrato - 2017
;
;	set it up with:
;	.__console_w	= max columns
;	.__console_h	= max rows
;
;	Display a char in location (__console_y),(__console_x)
;	A=char to display
;
;
;	$Id: f_ansi_char.asm$
;

        SECTION  code_clib
	PUBLIC	ansi_CHAR
	

	EXTERN	__console_y
	EXTERN	__console_x
	

.ansi_CHAR
	ld de,(__console_x)
	jp	$BE62
