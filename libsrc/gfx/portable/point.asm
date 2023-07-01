
	SECTION	code_graphics

	PUBLIC	point
	PUBLIC	_point
	PUBLIC	___point
	PUBLIC	point_callee
	PUBLIC	_point_callee
	PUBLIC	asm_point

	EXTERN	pointxy

; int point(int x, int y) __smallc;
point:
_point:
___point:
	ld	hl,sp+2
	ld	e,(hl)		;y
	ld	hl,sp+4
	ld	d,(hl)		;x
	ex	de,hl
	jr	asm_point

point_callee:
_point_callee:
	pop	bc		;return
	pop	hl		;y
	pop	de		
	ld	h,e		;x
	push	bc		;return address

asm_point:
	call	pointxy
	ld	hl,1
	ret	nz		;pixel set
	dec	hl
	ret
