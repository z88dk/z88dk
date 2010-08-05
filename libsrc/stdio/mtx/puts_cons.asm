;
;	Memotech MTX stdio
;
;	Print string to the screen
;
;	$Id: puts_cons.asm,v 1.1 2010-08-05 06:14:09 stefano Exp $
;


		XLIB	puts_cons


; Enter in with hl holding the address of string to print

.puts_cons
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	b,0
loop:
	ld	a,(hl)
	inc hl
	and a
	ret z
	ld	c,a
	rst 10h
	defb 192
	and a
	jr loop
