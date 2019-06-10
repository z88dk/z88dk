        SECTION code_fp_mbf64

        PUBLIC  fpclassify
	INCLUDE	"mbf64.def"

	EXTERN	___mbf64_FA

; Return 0 = normal
;        1 = zero
;        2 = nan
;        3 = infinite

fpclassify:
        ld      a,(___mbf64_FA+7)        ;exponent
        ld      hl,1
        and     a
        ret     z
        dec     hl
        ret
