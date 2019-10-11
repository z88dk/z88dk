

        SECTION code_fp_mbf64

        PUBLIC  l_f64_store
	PUBLIC	dstore

	EXTERN	___mbf64_FA

; Needs to be known as dstore so that scanf works without too much
; disturbance. This should override the dstore in z80_crt0s.lib
l_f64_store:
dstore:
	ld	de,___mbf64_FA
	ld	bc,8
	ex	de,hl
	ldir
	ex	de,hl
	ret
