;
; Peek at the console and get the character at the location
;


	SECTION	code_clib
	PUBLIC	cvpeek
	PUBLIC	_cvpeek
	PUBLIC	cvpeekr
	PUBLIC	_cvpeekr

	EXTERN	__console_w
	EXTERN	__console_h
	EXTERN	generic_console_vpeek


; int cvpeek(int x, int y) __smallc;
;
; -1 = Unknown character

cvpeekr:
_cvpeekr:
	ld	a,1
	jr	do_peek

cvpeek:
_cvpeek:
	xor	a		;Not in raw mode


do_peek:
	pop	hl	
	pop	bc		;c=y
	pop	de		;e=x
	push	de
	push	bc
	push	hl

	ld	b,e		;b = x
	ld	e,a		;e = raw mode

	ld	hl,-1		;invalid charactet
	ld	a,(__console_h)
	cp	c
	ret	c
	ld	a,(__console_w)
	cp	b
	ret	c
	ld	a,b		;a = x
	ld	b,c		;b = y
	ld	c,a		;c = x

	; b = y, c = x
	call	generic_console_vpeek
	ld	hl,-1
	ret	c
	ld	l,a
	ld	h,0
	ret
