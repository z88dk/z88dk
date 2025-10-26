
		SECTION	code_clib
		PUBLIC	asm_interrupt_handler
		EXTERN	l_jphl


; Calls the registered handlers in order
; Entry: hl = table to call
;
asm_interrupt_handler:
	push	bc
	push	de
	; af, hl already preserved
loop:
	ld	a,(hl)
	inc	hl
	or	(hl)
	jr	z,done
	push	hl
	ld	a,(hl)
	dec	hl
	ld	l,(hl)
	ld	h,a
	call	l_jphl
	pop	hl
	inc	hl
	jr	loop

done:
	pop	de
	pop	bc
	ret

