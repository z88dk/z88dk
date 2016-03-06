;       Z88 Small C+ Run time Library
;       l_gint variant to be used sometimes by the peephole optimizer
;

                SECTION   code_crt0_sccz80
PUBLIC l_gint7de
.l_gint7de
	ld  c,(hl)
	inc hl
	ld  b,(hl)
	ld	h,b
	ld	l,c
	add	hl,bc	;*2
	add	hl,bc	;*3
	add	hl,hl	;*6
	add	hl,bc	;*7
	pop bc
	pop	de
	add	hl,de
	push bc
	ret
