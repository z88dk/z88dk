;
;	PC6001 64/128 C Library
;
;	puts_cons
;
;	Stefano Bodrato - 2013
;
;
;	$Id: puts_cons.asm,v 1.1 2013-01-24 15:31:39 stefano Exp $
;

	XLIB  puts_cons

;
; Entry:        hl = points text
;

.puts_cons

	pop	bc
	pop	hl
	push	hl
	push	bc

	JP 30CFh    ; Print string in (HL)
