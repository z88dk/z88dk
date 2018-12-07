
		MODULE	tape_load
		SECTION	code_clib

		PUBLIC	tape_load
		PUBLIC	_tape_load


		EXTERN	asm_tape_load

tape_load:
_tape_load:
	call	asm_tape_load
	ld	hl,0
	ret	nc		;Success
	dec	hl
	ret

