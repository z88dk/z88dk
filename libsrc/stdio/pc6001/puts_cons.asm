;
;	PC6001 64/128 C Library
;
;	puts_cons
;
;	Stefano Bodrato - 2013
;
;
;	$Id: puts_cons.asm,v 1.2 2015-01-19 01:33:21 pauloscustodio Exp $
;

	PUBLIC  puts_cons

;
; Entry:        hl = points text
;

.puts_cons

	pop	bc
	pop	hl
	push	hl
	push	bc

	JP 30CFh    ; Print string in (HL)
