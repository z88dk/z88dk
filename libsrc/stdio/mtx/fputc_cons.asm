;
;	Memotech MTX stdio
;
;	(HL)=char to display
;
;	$Id: fputc_cons.asm,v 1.2 2011-05-09 14:31:38 stefano Exp $
;

	XLIB	fputc_cons

.fputc_cons
	ld	hl,2
	ld	b,h		; zero
	add	hl,sp
	ld	a,(hl)
	cp	13
	jr	nz,nocrlf
	ld	c,a
	rst 10h
	defb 192
	ld	a,10
.nocrlf
	ld	c,a
	rst 10h
	defb 192
	ret
