
    SECTION code_l_sccz80
    PUBLIC  l_i64_com
    EXTERN  __i64_acc
    EXTERN  l_cpl_64_mhl

; Entry: acc = LHS
; Exit:  z = acc is 0, nz = not zero
l_i64_com:
	ld	hl,__i64_acc
	jp	l_cpl_64_mhl
