; All ten VM1 extra ops (Zilog). jp of is always 10 (8080 jp).
; CS adc hl,bc is 14. RS ld a,(hl') is 11. Total 135:
;   sub hl,bc 10, sub hl,de 10, ld (hl),and (hl) 10, ld (hl),or (hl) 10,
;   ld (hl),xor (hl) 10, cp hl,bc 10, cp hl,de 10, ld hl,(de) 10,
;   ld (de),hl 10, jp of 10, adc hl,bc 14, ld a,(hl') 11, ret 10.
	MODULE	t_vm1_ext

	SECTION	code_compiler

._foo
	sub	hl,bc
	sub	hl,de
	ld	(hl),and (hl)
	ld	(hl),or (hl)
	ld	(hl),xor (hl)
	cp	hl,bc
	cp	hl,de
	ld	hl,(de)
	ld	(de),hl
	jp	of,L_of
L_of:
	adc	hl,bc
	ld	a,(hl')
	ret

	SECTION	code_compiler
	GLOBAL	_foo
