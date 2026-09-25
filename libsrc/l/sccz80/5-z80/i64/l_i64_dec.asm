
    SECTION code_l_sccz80
    PUBLIC  l_i64_dec
    EXTERN  __i64_acc

; Entry: acc = LHS
; Exit:  acc = acc - 1
l_i64_dec:
	ld	hl,__i64_acc
	ld	b,8
loop:
	dec	(hl)
	ld	c,(hl)
	inc	c		;borrow only if the byte wrapped to 0xff
	ret	nz
	inc	hl
	djnz	loop
        ret
