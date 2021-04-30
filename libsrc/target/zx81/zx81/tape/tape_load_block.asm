; int tape_load_block(void *addr, size_t len, unsigned char type)
; CALLER linkage for function pointers

PUBLIC tape_load_block

EXTERN asm_tape_load_block

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
   
   jp asm_tape_load_block
