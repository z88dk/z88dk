

	SECTION		code_fp_mbf64

	PUBLIC		___mbf64_setup_comparison

	INCLUDE		"mbf64.def"

	EXTERN		___mbf64_FA


; Put the two arguments into the required places
;
; Entry: dehl = right hand operand
; Stack: defw return address
;        defw callee return address
;        defb 8,left hand	; -> FPREG
;	   FA = right hand	; -> FPARG
___mbf64_setup_comparison:
        ld      hl,___mbf64_FA
        ld      de,___mbf64_FPREG
        ld      bc,8
        ldir
        ld      hl,4
        add     hl,sp
        ld      de,___mbf64_FPARG
        ld      bc,8
	ld	a,5
	ld	(___mbf64_VALTYP),a
        ldir
	pop	bc	;ret
	pop	de	;callee
	ld	hl,8	;remove left hand from the stack
	add	hl,sp
	ld	sp,hl
	push	de
	push	bc
	push	ix	;Save callers
	ld	ix,___mbf64_FPCOMPARE
	call	msbios
	pop	ix
	ret
