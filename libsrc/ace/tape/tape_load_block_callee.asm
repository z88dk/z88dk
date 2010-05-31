;
;      Tape load routine
;
;      Stefano 31/5/2010
;
;      int __CALLEE__ tape_load_block_callee(void *addr, size_t len, unsigned char type)
;

XLIB tape_load_block_callee
XDEF ASMDISP_TAPE_LOAD_BLOCK_CALLEE

.tape_load_block_callee

	pop hl
	pop bc
	pop de
	pop ix
	push hl

.asmentry

; enter : ix = addr
;         de = len
;          c = type

	scf
	call $18a7
        ld      hl,-1
	ret	nc		;error
	inc	hl		;okay
	ret

DEFC ASMDISP_TAPE_LOAD_BLOCK_CALLEE = asmentry - tape_load_block_callee
