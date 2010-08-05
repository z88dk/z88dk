;
;	Memotech MTX stdio
;
;	(HL)=char to display
;
;	$Id: fputc_cons.asm,v 1.1 2010-08-05 06:14:09 stefano Exp $
;

	XLIB	fputc_cons

.fputc_cons
	ld	hl,2
	ld	b,h		; zero
	add	hl,sp
	ld	a,(hl)
	ld	c,a
	rst 10h
	defb 192
	ret
