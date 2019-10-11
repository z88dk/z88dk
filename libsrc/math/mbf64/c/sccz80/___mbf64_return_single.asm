

        SECTION         code_fp_mbf64

        INCLUDE         "mbf64.def"

        EXTERN          ___mbf64_FA

; Return the value that's in the the FPREG
; We're in 64 bit mode so we have to copy to FA
___mbf64_return_single:
	ld	hl,___mbf64_FPREG 
	ld	de,___mbf64_FA 
	ld	bc,8
	ldir
	; Clear the least significant digits
	ld	hl,0
	ld	(___mbf64_FA + 0),hl
	ld	(___mbf64_FA + 2),hl
	pop	ix	;Restore callers
	ret
