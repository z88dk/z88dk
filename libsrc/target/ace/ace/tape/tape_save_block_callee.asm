;
;      Tape save routine
;
;      Stefano 31/5/2010
;
;      int __CALLEE__ tape_save_block_callee(void *addr, size_t len, unsigned char type)

PUBLIC tape_save_block_callee
PUBLIC _tape_save_block_callee
PUBLIC asm_tape_save_block

.tape_save_block_callee
._tape_save_block_callee

	pop ix
	pop bc
	pop de
	pop hl
	push ix

; enter : hl = addr
;         de = len
;          c = type

.asm_tape_save_block
		jp	$1820

