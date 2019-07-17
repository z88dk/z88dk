

	SECTION		code_fp_mbf32

	PUBLIC		___mbf32_setup_single
	EXTERN		___mbf32_FPREG
	EXTERN		___mbf32_VALTYP


; Used for the routines which accept single precision
;
; Entry: -
; Stack: defw return address
;        defw callee return address
;        defw left hand LSW
;        defw left hand MSW
___mbf32_setup_single:
	ld	a,4
	ld	(___mbf32_VALTYP),a
	ld	hl,4
	add	hl,sp
	ld	de,___mbf32_FPREG		;Store the right hand
	ld	bc,4
	ldir
IF !__CPU_8080__
	pop	hl
	push	ix
	push	hl
ENDIF
	ret
