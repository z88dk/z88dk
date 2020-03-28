
		SECTION		code_clib
		PUBLIC		asm_interrupt_add_handler

;
; Add an interrupt handler to the chain
; Entry: hl = pointer to chain
;        de = handler to add
;	  b = maximum chain length
; Exit:  nc = success
;	  c = failure

asm_interrupt_add_handler:
	ld	a,(hl)
	inc	hl
	or	(hl)
	jr	nz,try_next_slot
	; We have our slot, insert our handler
	ld	(hl),d
	dec	hl
	ld	(hl),e
	and	a
	ret
try_next_slot:
	inc	hl
	djnz	asm_interrupt_add_handler
	scf
	ret




