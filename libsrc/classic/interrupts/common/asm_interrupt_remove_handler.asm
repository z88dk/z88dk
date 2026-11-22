
		SECTION		code_clib
		PUBLIC		asm_interrupt_remove_handler

;
; Add an interrupt handler to the chain
; Entry: hl = pointer to chain
;        de = handler to remove
;	  b = maximum chain length
; Exit:  nc = success
;	  c = failure

asm_interrupt_remove_handler:
loop:
	ld	a,(hl)
	inc	hl
	cp	e
	jr	nz,try_next_slot
	ld	a,(hl)
	cp	d
	jr	nz,try_next_slot
	; We've found the handler to remove, lets shift everything down now
	ex	de,hl
	dec	de	;Slot we're trying to erase
	inc	hl	;Next slot
IF __CPU_INTEL__
	ld	a,b
	add	b
	ld	b,a
ELSE
	sla	b	;b * 2
ENDIF
move_chain:
	ld	a,(hl)
	ld	(de),a
	inc	hl
	inc	de
	djnz	move_chain
	; de points to last element in the chain, which should be cleared
	xor	a
	ld	(de),a
	inc	de
	ld	(de),a
	and	a
	ret
try_next_slot:
	inc	hl
	djnz	loop
	scf
	ret




