;
; Peek at the console and get the character at the location
;


	SECTION	code_clib
	PUBLIC	cvpeek
	PUBLIC	_cvpeek

	EXTERN	__console_w
	EXTERN	__console_h
	EXTERN	generic_console_vpeek


; int cvpeek(int x, int y) __smallc;
;
; -1 = Unknown character


cvpeek:
_cvpeek:
	pop	hl	
	pop	bc		;y
	pop	de		;x
	push	de
	push	bc
	push	hl

	ld	hl,-1		;invalid charactet
	ld	a,(__console_h)
	cp	c
	ret	nc
	ld	b,a
	ld	a,(__console_w)
	cp	e
	ret	nc
	ld	c,e
	; b = y, c = x
	call	generic_console_vpeek
	ld	hl,-1
	ret	c
	ld	l,a
	ld	h,0
	ret
