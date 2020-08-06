
    SECTION code_crt0_sccz80
    PUBLIC  l_i64_load
    PUBLIC  l_i64_loadi
    EXTERN  __i64_acc

l_i64_loadi:
	pop	hl
	call	l_i64_load
	push	hl
	ret

; Entry: hl = number to load
l_i64_load:
	ld	de,__i64_acc
	ld	bc,8
	ldir
	ret
