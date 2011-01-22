;
;	Put character to console
;
;	fputc_cons(char c)
;
;
;	$Id: fputc_cons.asm,v 1.3 2011-01-22 23:59:00 dom Exp $
;


		XLIB	fputc_cons


.fputc_cons
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
	cp	13
	jr	nz,fputc_cons1
	call	$B833	;txtoutput
	ld	a,10
.fputc_cons1
	jp	$B833	;txtoutput

