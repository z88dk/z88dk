

	SECTION		code_fp_mbfs

	PUBLIC		___mbfs_setup_comparison
	EXTERN		___mbfs_FPREG
	EXTERN		___mbfs_VALTYP
	EXTERN		___mbfs_CMPNUM
	EXTERN		msbios



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
___mbfs_setup_comparison:
	ld	a,4
	ld	(___mbfs_VALTYP),a
	; The right value needs to go into FPREG
	ld	(___mbfs_FPREG + 0),hl
	ld	(___mbfs_FPREG + 2),de
	pop	af		;Return address
	pop	hl		;Caller return address
	pop	de		;Left LSW
	pop	bc		;Left MSW
	push	hl
	push	af		;Our return address
	push	ix
	ld	ix,___mbfs_CMPNUM
	call	msbios
	pop	ix
	ret
