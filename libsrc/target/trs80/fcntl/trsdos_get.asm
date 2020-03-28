
	SECTION	code_clib

	PUBLIC	trsdos_get
	PUBLIC	_trsdos_get


; trsdos_get(fcb);

.trsdos_get
._trsdos_get
	; _FASTCALL
	ex de,hl
	call $13	; get byte
	ld	hl,-1	; EOF
	ret nz
	inc hl
	ld	l,a
	ret
