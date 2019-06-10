
	SECTION	code_clib

	PUBLIC	trsdos_get
	PUBLIC	_trsdos_get


; trsdos_get(fcb);

.trsdos_get
._trsdos_get
	; _FASTCALL
	ld	d,h
	ld	e,l
	call $13	; get byte
	ld	h,0
	ld	l,a
	ret z
	ld	hl,-1	; EOF
	ret
