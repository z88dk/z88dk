
    SECTION code_l_sccz80
    PUBLIC  l_i64_div_u
    EXTERN  __i64_acc
    EXTERN  __i64_extra
    EXTERN  l_divu_64_64x64

; Entry: acc = RHS (divisor)
;        sp+2 = LHS (dividend)
; Exit:  acc = LHS / RHS
l_i64_div_u:
	ld	hl,2
	add	hl,sp
	ld	de,__i64_extra
	ld	bc,8
	ldir
	ld	ix,__i64_extra
	call	l_divu_64_64x64
	ld	hl,__i64_extra	;holds quotient
	ld	de,__i64_acc
	ld	bc,8
	ldir
	pop	de
        ld      hl,8
        add     hl,sp
        ld      sp,hl
        push    de
        ret
