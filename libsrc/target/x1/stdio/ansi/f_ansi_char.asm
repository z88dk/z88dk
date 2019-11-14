;
; 	ANSI Video handling for the Sharp X1
;	Karl Von Dyson (for X1s.org) - 24/10/2013
;	Stefano Bodrato 10/2013
;
;	set it up with:
;	.__console_w	= max columns
;	.__console_h	= max rows
;
;	Display a char in location (__console_y),(__console_x)
;	A=char to display
;
;
;	$Id: f_ansi_char.asm,v 1.7 2016-07-20 05:45:02 stefano Exp $
;

    SECTION code_clib
    PUBLIC  ansi_CHAR

    EXTERN  generic_console_printc
    EXTERN  __console_x

ansi_CHAR:
    ld      bc,(__console_x)
    ld      d,a
    ld      e,0     ;not in raw mode
    jp      generic_console_printc	
