
SECTION code_fp

PUBLIC frexp
EXTERN fa
EXTERN dload

; float frexpf (float x, int *pw2);
frexp:
	ld	hl,4
	add	hl,sp
	call	dload
	pop	bc	;Ret
	pop	de	;pw2
	push	de
	push	bc
	ld	hl,fa+5
	ld	a,(hl)
	and	a
	ld	(hl),0
	jr	z,zero
	sub	$80
	ld	(hl),128
zero:
	ld	(de),a
	rlca
	sbc	a
	inc	de
	ld	(de),a
	ret
