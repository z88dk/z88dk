
    SECTION code_l_sccz80
    PUBLIC  l_i64_push
    EXTERN  __i64_acc


; Push what's in the ACC to the stack
l_i64_push:
	pop	de
	ld	hl,-8
	add	hl,sp
	ld	sp,hl
	push	de
	ld	de,__i64_acc
	ex	de,hl
	ld	bc,8
	ldir
	ret
