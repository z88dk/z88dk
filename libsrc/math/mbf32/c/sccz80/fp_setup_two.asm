

	SECTION		code_fp_mbfs

	PUBLIC		___mbfs_setup_two
	EXTERN		___mbfs_FPREG
	EXTERN		___mbfs_VALTYP


; Used for the routines which accept single precision
;
; Entry: -
; Stack: defw return address
;        defw callee return address
;        defw right hand LSW
;        defw right hand MSW
;        defw left hand LSW
;        defw left hand MSW
___mbfs_setup_two:
	ld	a,4
	ld	(___mbfs_VALTYP),a
	ld	hl,4
	add	hl,sp
	ld	de,___mbfs_FPREG		;Store the right hand
	ld	bc,4
	ldir
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	pop	hl
	push	ix
	push	hl
	ret
