;
; Autoload bootstrap for PMD-85
;

	SECTION BOOTSTRAP
	EXTERN	__DATA_END_tail

	defc	LDRSTART = $7fd7 
	defc	BLKLOAD = $8dc2

	org	LDRSTART

	jp	c,$8c40
	jp	nz,$8c40
	ld	hl,CRT_ORG_CODE
	ld	de,+((__DATA_END_tail - CRT_ORG_CODE) - 1)
	call	BLKLOAD
	jp	c,$8c40
	jp	nz,$8c40
	jp	CRT_ORG_CODE

	defs	12	;More space

_A7FFB:	defw	LDRSTART
