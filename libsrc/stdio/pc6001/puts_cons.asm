;
;	PC6001 64/128 C Library
;
;	puts_cons
;
;	Stefano Bodrato - 2013
;
;
;	$Id: puts_cons.asm,v 1.3 2016-05-15 20:15:46 dom Exp $
;

	SECTION code_clib
	PUBLIC  puts_cons_native

;
; Entry:        hl = points text
;

.puts_cons_native

	pop	bc
	pop	hl
	push	hl
	push	bc

	JP 30CFh    ; Print string in (HL)
