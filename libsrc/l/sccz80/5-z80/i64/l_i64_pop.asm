
    SECTION code_l_sccz80
    PUBLIC  l_i64_pop
    EXTERN  __i64_acc


; Pop what was TOS into the accumulator
; Entry: stack: defw ret address
;	        defs 8 - long
;
; hl is preserved
l_i64_pop:
	pop	de
	ld	c,l
	ld	b,h
	pop	hl
	ld	(__i64_acc+6),hl
	pop	hl
	ld	(__i64_acc+4),hl
	pop	hl
	ld	(__i64_acc+2),hl
	pop	hl
	ld	(__i64_acc+0),hl
	push	de
	ld	l,c
	ld	h,b
	ret
