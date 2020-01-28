
	SECTION	code_graphics

	PUBLIC	point
	PUBLIC	_point
	PUBLIC	point_callee
	PUBLIC	_point_callee
	PUBLIC	asm_point

	EXTERN	w_pointxy

; int point(int x, int y) __smallc;
point:
_point:
	ld	hl,sp+2
	ld	e,(hl)		;y
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	a,(hl)		;x
	inc	hl
	ld	h,(hl)
	jr	asm_point

point_callee:
_point_callee:
	pop	bc		;return
	pop	de		;y
	pop	hl		;x	
	push	bc		;return address

asm_point:
	call	w_pointxy
	ld	hl,1
	ret	nz		;pixel set
	dec	hl
	ret
