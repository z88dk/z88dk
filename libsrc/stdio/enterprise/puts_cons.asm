;
;	Enterprise 64/128 C Library
;
;	puts_cons
;
;	Stefano Bodrato - 2011
;
;
;	$Id: puts_cons.asm,v 1.3 2016-05-15 20:15:45 dom Exp $
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

	push	hl
	ld	b,255
	ld	c,b
	xor	a
	cpir		; Locate the string termination
	
	pop	de
	push	de
	scf
	sbc	hl,de	; Compute the number of chars to be printed
	pop	de		; block address
	
	ld	b,h
	ld	c,l		; block length
	
	ld      a,66h	; output channel (video)
	rst     30h		; EXOS
	defb    8	; write block
	ret

