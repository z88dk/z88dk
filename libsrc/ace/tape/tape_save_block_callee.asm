;
;      Tape save routine
;
;      Stefano 31/5/2010
;
;      int __CALLEE__ tape_save_block_callee(void *addr, size_t len, unsigned char type)

PUBLIC tape_save_block_callee
PUBLIC _tape_save_block_callee
PUBLIC ASMDISP_TAPE_SAVE_BLOCK_CALLEE

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

.asmentry
		jp	$1820

DEFC ASMDISP_TAPE_SAVE_BLOCK_CALLEE = # asmentry - tape_save_block_callee
