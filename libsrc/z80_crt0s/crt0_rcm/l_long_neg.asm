

		SECTION	code_crt0_seccz80
		PUBLIC	l_long_neg

; deHL = -deHL
l_long_neg:
	ex	de,hl
	defb	0x4d		;neg hl
	dec	hl
	ex	de,hl
	defb	0x4d		;neg hl
	dec	hl
	inc	l
	ret	nz
	inc	h
	ret	nz
	inc	de
	ret
