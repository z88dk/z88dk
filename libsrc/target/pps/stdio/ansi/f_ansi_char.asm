;
;       Sprinter C Library
;
; 	ANSI Video handling for Sprinter
;
;	$Id: f_ansi_char.asm,v 1.3 2016-06-12 16:06:43 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_CHAR
	
	EXTERN	__console_y
	EXTERN	__console_x

	EXTERN	__sprinter_attr
	


; a = character to print - need to handle attributes
.ansi_CHAR
	ex	af,af
	ld	a,(__console_y)
	ld	d,a
	ld	a,(__console_x)
	ld	e,a	
	ld	a,(__sprinter_attr)
	ld	b,a
	ex	af,af
	ld	c,$58		;PUTCHAR
	rst	$10
	ret
