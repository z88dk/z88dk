
    SECTION code_l_sccz80
    PUBLIC  l_i64_and
    EXTERN  __i64_acc

; Entry: acc = LHS
;        sp+2 = RHS
; Exit:  acc = LHS & RHS
l_i64_and:
	ld	hl,2
	add	hl,sp
	ex	de,hl
	ld	hl,__i64_acc
	ld	b,8
	and	a
loop:
	ld	a,(de)
	and	(hl)
	ld	(hl),a
	inc	hl
	inc	de
	djnz	loop
	pop	de
        ld      hl,8
        add     hl,sp
        ld      sp,hl
        push    de
        ret
