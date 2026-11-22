; GB-only ops (Zilog). Total 144:
;   ld a,(hl+) 8, ld (hl+),a 8, ld a,(hl-) 8, ld (hl-),a 8,
;   ldh a,(*) 12, ldh (*),a 12, ld a,(c) 8, ld (c),a 8,
;   ld hl,sp+* 12, add sp,* 16, swap a 8, ld (**),sp 20, ret 16.
	MODULE	t_gbz80_ext

	SECTION	code_compiler

._foo
	ld	a,(hl+)
	ld	(hl+),a
	ld	a,(hl-)
	ld	(hl-),a
	ldh	a,(80h)
	ldh	(80h),a
	ld	a,(c)
	ld	(c),a
	ld	hl,sp+2
	add	sp,4
	swap	a
	ld	(1234h),sp
	ret

	SECTION	code_compiler
	GLOBAL	_foo
