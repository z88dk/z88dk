

        SECTION         code_fp_mbfs

        PUBLIC          ceil
	EXTERN		msbios
	EXTERN		l_long_neg
	EXTERN		l_f32_slong2f
	EXTERN		___mbfs_setup_single
	EXTERN		___mbfs_return
        EXTERN          ___mbfs_FPINT
        EXTERN          ___mbfs_FPREG


ceil:
	call	___mbfs_setup_single
	ld	hl,___mbfs_FPREG+2
	ld	a,(hl)
	xor	$80
	ld	(hl),a
	push	af
        ld      ix,___mbfs_FPINT
	call	msbios
	; bcde = integer
	; Now normalise it again
	ex	de,hl
	ld	e,c
	ld	d,b
	pop	af
	rlca
	jr	nc,not_negative
	dec	d
not_negative:
	call	l_long_neg
	pop	ix
	jp	l_f32_slong2f
