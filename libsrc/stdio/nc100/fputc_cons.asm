;
;	Put character to console
;
;	fputc_cons(char c)
;
;
;	$Id: fputc_cons.asm,v 1.2 2001-04-13 14:13:59 stefano Exp $
;


		XLIB	fputc_cons


.fputc_cons
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
	call	$B833	;txtoutput
	ret

