
    SECTION code_l_sccz80
    PUBLIC  l_i64_sub
    EXTERN  __i64_acc
    EXTERN  l_sub_64_mde_mhl

; Entry: acc = RHS
;        sp+2 = LHS
; Exit:  acc = LHS - RHS
l_i64_sub:
	ld	hl,2
	add	hl,sp
	ex	de,hl
	ld	hl,__i64_acc
	call	l_sub_64_mde_mhl
	ld	hl,2
	add	hl,sp
	ld	de,__i64_acc
	ld	bc,8
	ldir
	pop	de
        ld      hl,8
        add     hl,sp
        ld      sp,hl
        push    de
        ret
