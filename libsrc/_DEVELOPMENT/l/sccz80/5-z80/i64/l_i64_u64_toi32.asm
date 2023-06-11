
    SECTION code_l_sccz80

    PUBLIC  l_i64_u64_toi32
    PUBLIC  l_i64_s64_toi32
    EXTERN  __i64_acc

; Entry: acc = value
; Exit:  dehl = long truncated value
;
l_i64_u64_toi32:
l_i64_s64_toi32:
	ld	hl,__i64_acc
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	ex	de,hl
	ret
