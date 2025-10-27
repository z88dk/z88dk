
    SECTION code_l_sccz80
    PUBLIC  l_i64_dec
    EXTERN  __i64_acc

; Entry: acc = LHS
; Exit:  acc = acc + 1
l_i64_dec:
	ld	hl,__i64_acc
	ld	b,8
loop:
	dec	(hl)
	ret	nz
	dec	hl
	djnz	loop
        ret
