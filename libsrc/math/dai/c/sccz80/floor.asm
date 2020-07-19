

        SECTION         code_fp_dai32

        PUBLIC          floor
	EXTERN		l_f32_slong2f
	EXTERN		___dai32_setup_single
	EXTERN		___dai32_return
        EXTERN          ___dai32_FPINT
        EXTERN          ___dai32_FPREG
        EXTERN          ___dai32_FPEXP


floor:
	call	___dai32_setup_single
	ld	a,(___dai32_FPREG+2)
	push	af
	ld	a,(___dai32_FPEXP)		;exponent
        call	___dai32_FPINT
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
	jp	l_f32_slong2f
