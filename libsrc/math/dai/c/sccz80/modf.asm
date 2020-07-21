

	SECTION		code_fp_dai32

	PUBLIC		modf
	EXTERN		floor
	EXTERN		ceil
	EXTERN		msbios
	EXTERN		___dai32_xsub
	EXTERN		___dai32_fpac
	EXTERN		l_glong
	EXTERN		___dai32_return

; double modf(double value, double *iptr)
modf:
	ld	hl,4
	add	hl,sp
	call	l_glong
IF __CPU_INTEL__
	ld	a,d
	rra
	jp	c,isnegative
ELSE
	bit	7,d
	jr	nz,isnegative
ENDIF
	push	de
	push	hl	
	call	floor
	pop	bc
	pop	bc
	jr	rejoin
isnegative:
	push	de
	push	hl
	call	ceil
	pop	bc
	pop	bc
rejoin:
	ld	c,l
	ld	b,h
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	; Now store the float
	ld	(hl),c
	inc	hl
	ld	(hl),b
	inc	hl
	ld	(hl),e
	inc	hl
	ld	(hl),d
IF __CPU_INTEL__|__CPU_GBZ80__
	ex	de,hl
	ld	(___dai32_fpac+2),hl
	ld	l,c
	ld	h,b
	ld	(___dai32_fpac),hl
ELSE
	ld	(___dai32_fpac),bc
	ld	(___dai32_fpac+2),de
ENDIF
	ld	hl,4
	add	hl,sp	
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	call	___dai32_xsub		; fpac = floor - value
        ld      hl,(___dai32_fpac+2)
	ex	de,hl
        ld      hl,(___dai32_fpac)
	; Now flip the sign
	ld	a,d
	xor	$80
	ld	d,a
	ret
	

