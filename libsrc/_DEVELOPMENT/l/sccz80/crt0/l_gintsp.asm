;       Z88 Small C+ Run time Library
;       l_gint variant to be used sometimes by the peephole optimizer
;

PUBLIC l_gintsp
.l_gintsp
	add	hl,sp
	inc hl
	inc hl
	ld a,(hl)
	inc     hl
	ld h,(hl)
	ld l,a
	ret
