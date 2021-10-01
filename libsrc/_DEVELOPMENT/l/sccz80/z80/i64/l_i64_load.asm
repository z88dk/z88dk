
    SECTION code_l_sccz80
    PUBLIC  l_i64_load
    EXTERN  __i64_acc

; Entry: hl = number to load
l_i64_load:
	ld	de,__i64_acc
	ld	bc,8
	ldir
	ret
