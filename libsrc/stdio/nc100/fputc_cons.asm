;
;	Put character to console
;
;	fputc_cons(char c)


		XLIB	fputc_cons


.fputc_cons
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
	call	$B833	;txtoutput
	ret

