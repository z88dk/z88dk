

	SECTION		code_fp_mbf64

	INCLUDE		"mbf64.def"

        EXTERN          ___mbf64_FA

; Put the two arguments into the required places
;
; This is for arithmetic routines, where we need to use 
; double precision values (so pad them out)
;
; Entry: dehl = right hand operand
; Stack: defw return address
;        defw callee return address
;        defb 8,left hand	; -> FPARG
;	   FA = right hand	; -> FPREG
___mbf64_setup_arith:
	ld	hl,___mbf64_FA
	ld	de,___mbf64_FPARG
	ld	bc,8
	ldir
	ld	hl,4
	add	hl,sp
	ld	de,___mbf64_FPREG
	ld	bc,8
	ld	a,5
	ld	(___mbf64_VALTYP),a
	ldir
	pop	bc	;ret
	pop	de	;callee
	ld	hl,8	;remove left hand from the stack
	add	hl,sp
	ld	sp,hl
	push	de
	push	ix	;Save callers
	push	bc
	ret
