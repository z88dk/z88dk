

SECTION code_fp

PUBLIC fpclassify

EXTERN ___mbf32_setup_single
EXTERN ___mbf32_FPREG

; Return 0 = normal
;	 1 = zero
;	 2 = nan
;	 3 = infinite

fpclassify:
    call    ___mbf32_setup_single
    ld      a,(___mbf32_FPREG+3)	;exponent
    ld      hl,1
    and     a
    ret     z
    dec     hl
    ret
