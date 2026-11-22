
	SECTION	code_fp_math48
	PUBLIC	_atof

        EXTERN  __convert_sdccf2reg
	EXTERN	l_glong
	EXTERN	_atof_impl


; sdcc implementation (l->r calling convention)
; (char *s)
._atof
	pop	bc
	pop	hl
	push	hl
	push	bc

	push	ix	;save callers
	push	hl
	call	_atof_impl
	pop	bc
	pop	ix
	exx
  ld a,l
   sub 2
   jr c, zero

   sla b
   rra
   rr b

   ld e,b
   ld h,c
   ld l,d
   ld d,a
	ret
zero:
	ld	hl,0
	ld	d,h
	ld	e,l
	ret
