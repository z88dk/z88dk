;
;	Jupiter ACE Routines
;
;	Print character to the screen
;
;	$Id: fputc_cons.asm,v 1.1 2010-05-20 07:28:21 stefano Exp $
;

	XLIB  fputc_cons

;
; Entry:        char to print
;


.fputc_cons
	ld	hl,2
	add	hl,sp
	ld	a,(hl); Now A contains the char to be printed
	cp	12
	jp	z,$a24
	jp	$3ff
