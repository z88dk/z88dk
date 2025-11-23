
    SECTION code_l_sccz80
    PUBLIC  l_i64_store
    PUBLIC  l_i64_copy
    EXTERN  __i64_acc

; Entry: bc = number to store
l_i64_store:
	ld	l,c
	ld	h,b
l_i64_copy:
	; This copy entry point should check for equality and
	; return early
	ld	de,__i64_acc
	ex	de,hl
	ld	bc,8
	ldir
	ret
