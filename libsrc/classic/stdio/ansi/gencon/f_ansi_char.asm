;
; 	ANSI Video handling for interworking with gencon
;
;	set it up with:
;	.__console_w	= max columns
;	.__console_h	= max rows
;
;	Display a char in location (__console_y),(__console_x)
;	A=char to display
;
	
	MODULE __gencon_ansi_CHAR
        SECTION code_clib
	PUBLIC	__gencon_ansi_CHAR
	
	EXTERN	__console_x
	EXTERN	generic_console_printc
	


__gencon_ansi_CHAR:
	ld	bc,(__console_x)
	ld	d,a
	ld	e,0
	jp	generic_console_printc

