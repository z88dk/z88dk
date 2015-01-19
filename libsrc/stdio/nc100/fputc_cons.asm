;
;	Put character to console
;
;	fputc_cons(char c)
;
;
;	$Id: fputc_cons.asm,v 1.4 2015-01-19 01:33:20 pauloscustodio Exp $
;


		PUBLIC	fputc_cons


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

