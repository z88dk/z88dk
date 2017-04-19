;
;	Memotech MTX stdio
;
;	(HL)=char to display
;
;	$Id: fputc_cons.asm,v 1.4 (git imported) Exp $
;

	SECTION code_clib
	PUBLIC	fputc_cons_native

.fputc_cons_native
	ld	hl,2
	ld	b,h		; zero
	add	hl,sp
	ld	a,(hl)
IF STANDARDESCAPECHARS
	cp	10
ELSE
	cp	13
ENDIF
	jr	nz,nocrlf
	ld	c,13
	rst 10h
	defb 192
	ld	a,10
.nocrlf
	ld	c,a
	rst 10h
	defb 192
	ret
