;
;	Memotech MTX stdio
;
;	(HL)=char to display
;
;	$Id: fputc_cons.asm,v 1.3 2015-01-19 01:33:20 pauloscustodio Exp $
;

	PUBLIC	fputc_cons

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
