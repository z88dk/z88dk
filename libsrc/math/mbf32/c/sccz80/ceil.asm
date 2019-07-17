

        SECTION         code_fp_mbf32

        PUBLIC          ceil
	EXTERN		msbios
	EXTERN		l_long_neg
	EXTERN		l_f32_slong2f
	EXTERN		___mbf32_setup_single
	EXTERN		___mbf32_return
        EXTERN          ___mbf32_FPINT
        EXTERN          ___mbf32_FPREG


ceil:
	call	___mbf32_setup_single
	ld	hl,___mbf32_FPREG+2
	ld	a,(hl)
	xor	$80
	ld	(hl),a
	push	af
IF __CPU_8080__
        call	___mbf32_FPINT
ELSE
        ld      ix,___mbf32_FPINT
	call	msbios
ENDIF
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
IF !__CPU_8080__
	pop	ix
ENDIF
	jp	l_f32_slong2f
