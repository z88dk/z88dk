

	SECTION		code_fp_mbf32

	PUBLIC		___mbf32_setup_arith
	EXTERN		___mbf32_FPREG
	EXTERN		___mbf32_VALTYP


; Put the two arguments into the required places
;
; This is for arithmetic routines, where we need to use 
; double precision values (so pad them out)
;
; Entry: dehl = right hand operand
; Stack: defw return address
;        defw callee return address
;        defw left hand LSW
;        defw left hand MSW
___mbf32_setup_arith:
	ld	a,4
	ld	(___mbf32_VALTYP),a
	; The right value needs to go into FPREG
	ld	(___mbf32_FPREG + 0),hl
	ld	(___mbf32_FPREG + 2),de
	pop	af		;Return address
	pop	hl		;Caller return address
	pop	de		;Left LSW
	pop	bc		;Left MSW
	push	hl
	push	ix
	push	af		;Our return address
	ret
