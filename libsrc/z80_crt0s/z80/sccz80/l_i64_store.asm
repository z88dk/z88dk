
    SECTION code_crt0_sccz80
    PUBLIC  l_i64_store
    EXTERN  __i64_acc

; Entry: bc = number to store
l_i64_store:
	ld	l,c
	ld	h,b
	ld	de,__i64_acc
	ex	de,hl
	ld	bc,8
	ldir
	ret
