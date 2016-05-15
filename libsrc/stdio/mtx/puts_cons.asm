;
;	Memotech MTX stdio
;
;	Print string to the screen
;
;	$Id: puts_cons.asm,v 1.3 2016-05-15 20:15:45 dom Exp $
;

		SECTION code_clib
		PUBLIC	puts_cons_native


; Enter in with hl holding the address of string to print

.puts_cons_native
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
