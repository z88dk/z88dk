
SECTION code_fp

PUBLIC frexp

; float frexpf (float x, int8_t *pw2);
frexp:
	pop	af	;Return
	pop	bc	;pw2
	pop	hl	;float
	pop	de
	push	de
	push	hl
	push	bc
	push	af

	ld	a,d
	and	a
	ld	d,0
	jr	z,zero
	sub	$80
	ld	d,$80	;And set to non-scaled
zero:
	ld	(bc),a
	inc	bc
	rlca
	sbc	a
	ld	(bc),a
	ret
