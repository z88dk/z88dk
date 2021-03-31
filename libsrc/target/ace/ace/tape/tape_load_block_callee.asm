;
;      Tape load routine
;
;      Stefano 31/5/2010
;
;      int __CALLEE__ tape_load_block_callee(void *addr, size_t len, unsigned char type)
;

PUBLIC tape_load_block_callee
PUBLIC _tape_load_block_callee
PUBLIC asm_tape_load_block

.tape_load_block_callee
._tape_load_block_callee

	pop ix
	pop bc
	pop de
	pop hl
	push ix

.asm_tape_load_block

; enter : hl = addr
;         de = len
;          c = type

	scf
	call $18a7
        ld      hl,-1
	ret	nc		;error
	inc	hl		;okay
	ret

