

        SECTION         code_fp_mbf32

        PUBLIC          floor
	EXTERN		msbios
	EXTERN		l_f32_slong2f
	EXTERN		___mbf32_setup_single
	EXTERN		___mbf32_return
        EXTERN          ___mbf32_FPINT
        EXTERN          ___mbf32_FPREG


floor:
	call	___mbf32_setup_single
	ld	a,(___mbf32_FPREG+2)
	push	af
        ld      ix,___mbf32_FPINT
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
	pop	ix
	jp	l_f32_slong2f
