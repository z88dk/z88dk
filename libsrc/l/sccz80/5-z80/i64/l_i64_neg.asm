
    SECTION code_l_sccz80
    PUBLIC  l_i64_neg
    EXTERN  __i64_acc
    EXTERN  l_neg_64_mhl

; Entry: acc = LHS
; Exit:  z = acc is 0, nz = not zero
l_i64_neg:
	ld	hl,__i64_acc
	jp	l_neg_64_mhl
