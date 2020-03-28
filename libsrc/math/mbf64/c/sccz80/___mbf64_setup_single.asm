

	SECTION		code_fp_mbf64

	INCLUDE		"mbf64.def"

        EXTERN          ___mbf64_FA

; Put the two arguments into the required places
;
; Used for the routines which accept single precision
;
; Entry: FA = operand
___mbf64_setup_single:
	ld	hl,___mbf64_FA
	ld	de,___mbf64_FPREG
	ld	bc,8
	ld	a,5
	ld	(___mbf64_VALTYP),a
	ldir
	pop	hl	;return
	push	ix
	jp	(hl)
