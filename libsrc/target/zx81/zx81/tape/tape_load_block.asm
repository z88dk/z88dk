; int tape_load_block(void *addr, size_t len, unsigned char type)
; CALLER linkage for function pointers

PUBLIC tape_load_block

EXTERN tape_load_block_callee
EXTERN ASMDISP_TAPE_LOAD_BLOCK_CALLEE

.tape_load_block

	pop de
	pop bc
	ld a,c
	pop bc
	pop hl
	push hl
	push bc
	push bc	; altered !
	push de
   
   jp tape_load_block_callee + ASMDISP_TAPE_LOAD_BLOCK_CALLEE
