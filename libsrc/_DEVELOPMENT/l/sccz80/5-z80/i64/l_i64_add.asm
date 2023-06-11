
    SECTION code_l_sccz80
    PUBLIC  l_i64_add
    EXTERN  __i64_acc
    EXTERN  l_add_64_mde_mhl

; Entry: acc = RHS
;        sp+2 = LHS
; Exit:  acc = LHS + RHS
l_i64_add:
	ld	hl,2
	add	hl,sp
	ld	de,__i64_acc
	call	l_add_64_mde_mhl
	pop	de
        ld      hl,8
        add     hl,sp
        ld      sp,hl
        push    de
        ret
