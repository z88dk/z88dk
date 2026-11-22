
    SECTION code_l_sccz80
    PUBLIC  l_i64_inc
    EXTERN  __i64_acc

; Entry: acc = LHS
; Exit:  acc = acc + 1
l_i64_inc:
	ld	hl,__i64_acc
	ld	b,8
loop:
	inc	(hl)
	ret	nz
	inc	hl
	djnz	loop
        ret
