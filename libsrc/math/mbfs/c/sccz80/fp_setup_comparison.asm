

	SECTION		code_fp_mbfs

	PUBLIC		fp_setup_comparison
	EXTERN		FPREG
	EXTERN		CMPNUM



; Put the two arguments into the required places
;
; This is for comparisonmetic routines, where we need to use 
; double precision values (so pad them out)
;
; Entry: dehl = right hand operand
; Stack: defw return address
;        defw callee return address
;        defw left hand LSW
;        defw left hand MSW
fp_setup_comparison:
	; The right value needs to go into FPREG
	ld	(FPREG + 0),hl
	ld	(FPREG + 2),de
	pop	af		;Return address
	pop	hl		;Caller return address
	pop	de		;Left LSW
	pop	bc		;Left MSW
	push	hl
	push	af		;Our return address
	call	CMPNUM
	ret
