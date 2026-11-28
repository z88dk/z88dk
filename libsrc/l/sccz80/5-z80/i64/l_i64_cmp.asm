; Signed 64-bit compare of the stacked operand with __i64_acc
;
; exit  : operand removed from the stack, hl = 1
;         carry set if operand < __i64_acc, z set if equal
;
; The sign of the difference is wrong when the subtraction overflows, so
; operands of unlike sign are decided by the sign of the operand alone.

                SECTION   code_l_sccz80
                PUBLIC    l_i64_cmp
		EXTERN	l_sub_64_mde_mhl
		EXTERN	__i64_acc
l_i64_cmp:
	ld	hl,4 + 7
	add	hl,sp
	ld	c,(hl)		;sign byte of the operand
	ld	a,(__i64_acc+7)
	xor	c
	ld	b,a		;bit 7 set if the signs differ
	ld	hl,4
	add	hl,sp
	ex	de,hl
	ld	hl,__i64_acc
	call	l_sub_64_mde_mhl	;de = de - hl
	ld	hl,4 + 7
	add	hl,sp
	ld	a,(hl)
	bit	7,b
	jr	z,sign_ok
	ld	a,c		;unlike signs: less if the operand is negative
sign_ok:
	and	a		;negative: nz and carry clear
	jp	p,positive
	pop	bc
	pop	de
	ld	hl,8
	add	hl,sp
	ld	sp,hl
	push	de
	push	bc
        ld      hl,1    ; Saves some mem in comparision unfunctions
	scf
	ret
positive:
	ld	b,7
	ld	a,(hl)
loop1:
	dec	hl
	or	(hl)
	djnz	loop1
	pop	bc
	pop	de
	ld	hl,8
	add	hl,sp
	ld	sp,hl
	push	de
	push	bc
	and	a	;Reflect equality + clear carry
        ld      hl,1    ; Saves some mem in comparision unfunctions
        ret
