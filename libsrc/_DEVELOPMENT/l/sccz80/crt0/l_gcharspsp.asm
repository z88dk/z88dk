;       Z88 Small C+ Run time Library
;       l_gchar variant to be used sometimes by the peephole optimizer
;

PUBLIC l_gcharspsp
.l_gcharspsp
	add	hl,sp
	inc hl
	inc hl
	ld a,(hl)
	ld l,a
	rlca
	sbc   a,a
	ld h,a
	ex	(sp),hl
	jp (hl)
