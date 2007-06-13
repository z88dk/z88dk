;
;      Tape load routine
;
;      djm 16/10/2001
;
;      int __CALLEE__ tape_load_block_callee(void *addr, size_t len, unsigned char type)
;

XLIB tape_load_block_callee
XDEF ASMDISP_TAPE_LOAD_BLOCK_CALLEE

.tape_load_block_callee

	pop hl
	pop bc
	ld a,c
	pop de
	pop ix
	push hl

; enter : ix = addr
;         de = len
;          a = type

	scf
        call    1366            ;call ROM3 load routine
        ld      hl,-1
	ret	nc		;error
	inc	hl		;okay
	ret

DEFC ASMDISP_TAPE_LOAD_BLOCK_CALLEE = asmentry - tape_load_block_callee
