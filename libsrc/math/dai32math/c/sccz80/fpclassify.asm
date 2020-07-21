

SECTION code_fp

PUBLIC fpclassify

EXTERN ___dai32_setup_single
EXTERN ___dai32_fpac

; Return 0 = normal
;	 1 = zero
;	 2 = nan
;	 3 = infinite

fpclassify:
	call    ___dai32_setup_single
	ld	a,(___dai32_fpac+0)	;exponent
	ld	hl,1
	and	127
	ret	z
	dec	hl
	ret
