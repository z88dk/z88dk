;
; Vpeek operation that doesn't match
;
; Used to stub out implementations for unwanted screenmodes
;
;
		SECTION		code_clib
		PUBLIC		vpeek_noop

vpeek_noop:
		scf
		ret
