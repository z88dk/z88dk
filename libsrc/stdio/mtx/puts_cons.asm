;
;	Memotech MTX stdio
;
;	Print string to the screen
;
;	$Id: puts_cons.asm,v 1.2 2015-01-19 01:33:20 pauloscustodio Exp $
;


		PUBLIC	puts_cons


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
