; int tape_save_block(void *addr, size_t len, unsigned char type)
; CALLER linkage for function pointers

PUBLIC tape_save_block

EXTERN tape_save_block_callee
EXTERN ASMDISP_TAPE_SAVE_BLOCK_CALLEE

.tape_save_block

	pop de
	pop bc
	ld a,c
	pop bc
	pop hl
	push hl
	push bc
	push bc	; altered !
	push de

   jp tape_save_block_callee + ASMDISP_TAPE_SAVE_BLOCK_CALLEE
