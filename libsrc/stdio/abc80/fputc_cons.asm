;
;	ABC80 Routines
;
;	Print character to the screen
;
;       We can corrupt any register
;
;
;	$Id: fputc_cons.asm,v 1.2 2001-04-13 14:13:59 stefano Exp $
;

	XLIB  fputc_cons

;
; Entry:        char to print
;


.fputc_cons
	ld	hl,2
	add	hl,sp
	ld	a,(hl); Now A contains the char to be printed
	

	ret
