

        SECTION         code_fp_mbf64

        INCLUDE         "mbf64.def"

        EXTERN          ___mbf64_FA

; Return the value that's in the the FPREG
; We're in 64 bit mode so we have to copy to FA
___mbf64_return:
	ld	hl,___mbf64_FPREG
	ld	de,___mbf64_FA
	ld	bc,8
	ldir
	pop	ix	;Restore callers
	ret
